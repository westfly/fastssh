#!/usr/bin/env bash
#author : yweiyun@gmail.com
deploy="/tmp/mlogin"
password_list="op"
machine_data="$deploy/machine.dat"
#用于便捷的登陆机器，一个简单的封装
function get_machine_list_multi()
{
    local machine="$1"
    local num=$2
    ip_candidate=$(awk '{if ($1~/^#/)next; if($'"$num"'~/'"$machine"'/)print $1}' $machine_data)
    echo $ip_candidate;
}
function get_machine_list_single()
{
    local machine="$1"
    local num=$2
    ip_candidate=$(awk -v machine=$machine '{if ($0~/^#/)next;
                split($'"$num"', arr, ".");
                if (length(arr) > 1)
                {
                  if (match(arr[3], '"$machine"') > 0 || match(arr[4], machine) > 0)
                  {
                        print $1;
                  }
                }
                else
                {
                  if (length(arr[1]) > 0 && match(arr[1], machine) > 0)
                  {
                        #print $1, arr[1], machine;
                        print $1;
                  }
                }
                }' $machine_data)
    echo $ip_candidate
}
function get_ssh_param()
{
    local host_name=$1
    local user_name=$2
    if [[ -z $user_name ]]; then
        echo "$host_name  -o StrictHostKeyChecking=no"
    else
        echo "$host_name -l $user_name  -o StrictHostKeyChecking=no"
    fi
}
function passless_login_wrapper()
{
    local host=$1
    local user=$2
    ssh -f $(get_ssh_param $host $user)
    if [[ $? -eq 0 ]]; then
        echo "success"
        exit
    fi
    sshpass_login $host $user
}
function sshpass_login()
{
    local host=$1
    local user=$2
    for passwd in ${password_list[*]}
    do
        $deploy/sshpass -p $passwd ssh $(get_ssh_param $host $user)
        if [[ $? -eq 0 ]]; then
            exit
        fi
    done
}
function match_wrapper()
{
    local machine="$1"
    local num=$2
    local user=$3
    count=$(echo $machine | awk -F'.' '{print NF}')
    if [[ $count -gt 0 ]]; then
      ip_candidate=$(get_machine_list_multi $machine $num)
    else
      ip_candidate=$(get_machine_list_single $machine $num)
    fi
    if [[ -z $ip_candidate ]]; then
      return 1
    fi
    arr=($ip_candidate)
    #len=${#ip_candidate[@]}
    len=${#arr[@]}
    count=0
    if [[ $len -gt 1 ]]; then
        x=0
        for ip in ${ip_candidate[@]}
        do
            echo "candidate $x,$ip"
            let x++
        done
        read -p "select " count
    fi
    echo $count, $len, ${arr[$count]}
    login_host=${arr[$count]}
    if [[ ${#user} -gt 0 && "$login_host" =~ "@" ]]; then
      host=${login_host#*@}
      #ssh $host -l $user
      passless_login_wrapper $host $user
    else
      #ssh ${arr[$count]}
      passless_login_wrapper ${arr[$count]}
    fi
    return 0
}
#set -x
pattern=$1
user=$2
match_wrapper $pattern 2 $user
if [[ $? -ne 0 ]]; then
  match_wrapper $pattern 1 $user
fi
