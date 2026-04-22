---
title: 记录MacOS使用PD18安装Ubuntu22
toc: true
mathjax: true
date: 2023-12-21 13:58:41
tags:
  - MacOS教程
  - PD18
  - 虚拟机
summary:
cover: 
top:
img:
categories:
  - 记录
---



最近工作上要搞一些Python解释器和第三方库的交叉编译和移植的工作，需要在虚拟机里面操作，过程中遇到了一些问题，所以再此记录。

### 一、安装Parallels Desktop 18

我这里用的是一个盗版的版本。链接就不放在这里了，不过还是建议大家购买正版授权，打击盗版。附[官网链接](https://www.parallels.cn/)

### 二、安装Ubuntu22系统

这里有两种方式安装。

第一种打开pd18软件，界面有直接可以选择的系统镜像，直接安装。

第二种需要自行去官方下载对应版本iso镜像，进行本地安装。

两种方式都是可行的，不过选择第二种的同学注意不要下载错版本，要选择[arm版本](https://cn.ubuntu.com/download/server/arm)的下载，因为现在MacBook都是ARM架构的系统。

我选择的是第一种，选择之后它会自己安装和下载。

![1703139181612](/img/1703139181612.jpg)

安装完成之后会提示输入新的系统密码，因为我已经安装过了，没有截图，设置一个常用密码即可。之后就可以进入系统。

### 三、切换系统软件源

系统默认的更新软件源的链接是`http://c.archive.ubuntu.com/ubuntu/`，对于国内来说访问可能有一些障碍，所以要把这个链接改成国内链接。

1. 备份sources.list

   ```shell
   sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
   ```

2. 修改sources.list

   ```shell
   sudo vi /etc/apt/sources.list
   ```

我使用的是阿里云源：

```she
deb https://mirrors.aliyun.com/ubuntu-ports/ focal main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu-ports/ focal main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu-ports/ focal-security main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu-ports/ focal-security main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu-ports/ focal-updates main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu-ports/ focal-updates main restricted universe multiverse

# deb https://mirrors.aliyun.com/ubuntu-ports/ focal-proposed main restricted universe multiverse
# deb-src https://mirrors.aliyun.com/ubuntu-ports/ focal-proposed main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu-ports/ focal-backports main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu-ports/ focal-backports main restricted universe multiverse
```

还有很多其他的源，大家可以自行百度，选择的时候一定要选择arm更新链接。如果选择其他链接，更新时会报错。防止踩坑。

### 四、配置网络

默认配置选择的是**共享网络**

![1703140559778](/img/1703140559778.jpg)

如果想使用宿主机的代理，那么需要简单配置一下

1. 首先将源改为**桥接网络-WiFi**

2. 打开系统设置修改系统代理

   ![1703140679913](/img/1703140679913.jpg)

   将代理ip改为宿主机的内网ip，端口填宿主机代理的端口即可

   ![1703140774037](/img/1703140774037.jpg)

   这样网络配置就完成了。

### 五、更新和升级软件

```shell
sudo apt update
sudo apt upgrade
```

### 六、优化终端界面和安装git、vim

1. 安装git

   ```she
   sudo apt install git
   ```

2. 配置git相关信息

   ```shell
   git config --global user.name QingFeng
   git config --global user.email xxx@gmail.com
   ```

3. 安装oh-my-zsh

   ```shell
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
   ```

   完成后终端的界面就会变的简洁了一些，里面还有很多配置，比如主题，字体之类。可以在配置中根据个人喜好修改。

4. 安装vim

   ```shell
   sudo apt install vim
   ```

   安装vim时可能报错像**vim-common版本不对**的问题，这里首先卸载vim-common

   ```shell
   sudo apt remove vim-common
   ```

   之后再重新执行安装vim的命令
