# fastssh
===
[fastssh](https://github.com/westfly/fastssh) with name or part ip within localnetwork

介绍
---
fastssh 是一个快速登录内网机器的shell封装，比较实用，需要的人可以拿去。

应用场景是在内网登录机器的时候，避免输入全部的ip地址，或者可以定义别名，避免记忆ip地址。
节省您宝贵的时间。
安装
---
编译sshpass，如果没有root权限，自己编译一个放在fastssh目录下即可

进入 your_install_path/fastssh，修改
```
  deploy="/your_install_path/fastssh" 
  password_list="youpasslist"      #定制通用密码，作为轮询用
```
定制你的machine.dat，配置dat文件格式示例
```
 #ngix 注释
 fake_user@10.130.134.116 nginx
 默认用户名 机器       别名
```
install_path添加到.bashrc中。
```
  export PATH=$PATH:your_install_path/fastssh_
```

用法
---
```
mlogin.sh 44.55
mlogin.sh 44
mlogin.sh nginx
```
如果有多个选项，会弹出让用户选择，请选择需要登录的机器。
如果您需要对多个机器同时进行操作，[mssh](https://github.com/westfly/mssh) 可能适合您。

备注
---
只是一个在工作中使用的简单的小工具，并不代表作者的真实编程水平，好用是王道，如果有问题请
给我反馈，真诚希望它给你在工作中带来方便，谢谢。


