---
title: 安装rclone挂载pikpak作为影视盘
toc: true
date: 2024-03-27 10:41:46
tags:
  - rclone
  - Pikpak
  - 网盘
cover:
categories:
  - 教程
---

之前PT刷流的时候开了几台年合约NC的vps，目前馒头等几个pt站已经刷毕业了。vps处于闲置的状态。所以准备捣鼓一下，把其中的一台搭建一个小电影影视库，硬盘使用pikpak云盘，懂的都懂。

----

### 一、安装rclone

根据[官方文档](https://rclone.org/install/)使用以下命令安装

```bash
sudo -v ; curl https://rclone.org/install.sh | sudo bash
```

检查是否安装成功

```shell
root@baiweispace:~# rclone version
rclone v1.66.0
- os/version: debian 11.9 (64 bit)
- os/kernel: 5.10.0-28-amd64 (x86_64)
- os/type: linux
- os/arch: amd64
- go/version: go1.22.1
- go/linking: static
- go/tags: none
```

### 二、挂载Pikpak

执行：

```shell
rclone config
```

您应该会看见

```shell
Current remotes:

Name                 Type
====                 ====
pikpak               pikpak

e) Edit existing remote
n) New remote
d) Delete remote
r) Rename remote
c) Copy remote
s) Set configuration password
q) Quit config
e/n/d/r/c/s/q> n
```

这里我已经挂载过pikpak了。

没有挂载过的朋友直接输入n，创建一个新的远程连接，输入自定义连接名称。

紧接着会出来很多配置类型。

这里我们选择38。

```shell
37 / Pcloud
   \ (pcloud)
38 / PikPak
   \ (pikpak)
39 / Proton Drive
   \ (protondrive)
```

需要注意的是这里的38不是不变的，注意选择Pikpak的选项。

之后就是输入Pikpak的账号和密码：

```shell
Option user.
Pikpak username.
Enter a value.
user> username

Option pass.
Pikpak password.
Choose an alternative below.
y) Yes, type in my own password
g) Generate random password
y/g> y
Enter the password:
password: your password
Confirm the password:
password: Confirm your password
```

剩下的选项回车使用默认值即可。

现在网盘已经挂载好了。执行命令查看挂载是否成功。

```shell
root@baiweispace:~# rclone ls pikpak:
4468597077 电影/国语/跛豪[国语配音+中文字幕].To.Be.Number.One.1991.1080p.CATCHPLAY.WEB-DL.AAC2.0.H.264-DreamHD/To.Be.Number.One.1991.1080p.CATCHPLAY.WEB-DL.AAC2.0.H.264-DreamHD.mkv
1610781630 电影/国语/最好的相遇/最好的相遇.2023.HD.1080P.国语中字.mkv
```

可以看到网盘中的文件已经被罗列了出来。

挂载到本地

```shell
mkdir /mnt/pikpak
rclone mount pikpak: /mnt/pikpak --allow-other --allow-non-empty --vfs-cache-mode writes --daemon 
```

这样网盘就成功被挂载到了本地。

### 三、扩展用法

在平时使用的时候一般的流程都是先把文件下载到网盘，然后再从vps的服务读取网盘中的文件进行使用。

但是特殊情况，比如我们可以利用vps的大带宽优势，使用下载器下载文件到本地。在将文件上传到网盘。这是一个反向的过程。

上传文件到网盘：

```shell
rclone copy -P /home/baiwei/your/file/ pikpak:百威空间/path/to/folder/ --transfers=16
```

----

好了，这期教程就到这里了。有任何问题都可以在下方留言。再见👋🏻...
