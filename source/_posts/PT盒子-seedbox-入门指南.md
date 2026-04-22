---
title: PT盒子(seedbox)入门指南
toc: true
date: 2024-03-19 13:50:18
tags:
  - pt盒子
  - 刷流
cover: /img/PT盒子-seedbox-入门指南-005.png
categories:
  - PT
---

### 什么是PT盒子（seedbox）

**种子盒子**（英语：seedbox）是用于从点对点网络上传和下载电脑文件的高带宽远程服务器。其带宽通常介于100 Mbit/s至20 Gbit/s。种子盒子获取文件后，有访问权限的人可以将文件下载到他们的个人电脑。

以上是维基百科的解释，简单的讲盒子就是一种大带宽主要指上行带宽的远程服务器。

本文提供一个搭建刷流服务器的基本配置流程。目前我也处于入门阶段，写下本文，以备后续查阅。

### 盒子选择购买

用于刷流的vps服务商常见的有：hz(HETZNER)、op(oneprovider)、nc(netcup)、甲骨文等，这里主要介绍我在使用的进行记录。

**hz**是目前刷流的主力服务器，大部分的pter都聚集于此。所以使用hz盒子，刷流的效率会很高，每个月大约在200T左右。但是hz**注册比较麻烦**，账号容易被BAN，楼主也还没有注册上。以后注册了再在此补充。

[hz购买链接](https://www.hetzner.com/sb/?country=ot)

**op**属于是hz退而求其次的选择，他刷流的效率大约在hz的70%左右。注册容易，价格也会便宜一些，这个服务器是共享带宽，所以非常看脸。这也是我第一台刷流的vps。根据我的经验尽量**不要选择HDD**的服务器，据说他家硬盘都很老，属于是老弱病残了。读写效率低下。

[op购买链接](https://oneprovider.com/dedicated-servers/paris-france)

**nc**是我现在主力的刷流服务器。带宽是2.5G，实际使用下来上传可以达到200M/s以上，价格也不贵，每个月在8欧左右，折人民币60元。但是他家的缺点是有**合约**和**限流**，之前老款G9.5每个月120T流量，用完限流，现在新款G11设备性能提升了，但是每天只有3T流量，用完限制到300M带宽。这就比较坑了。不过现在在控制面板流量统计的地方，一直显示的是0，不知道是BUG，还是有意而为之。关于合约分为月合约价格高一点，年合约，价格低点，所有合约要取消的话需要**提前一个月在控制台提交申请**，也就是说你准备只用一个月，那么下单完就要立马提交取消合约，否则会被再延长一个月。

[nc购买链接](https://www.netcup.eu/vserver/)

### 系统安装

- nc

  机器到手之后会收到邮件。里面包含服务器ip，root账号密码以及控制到账号密码。

  1. 登录控制台

  2. 修改**Current driver** 

     ![pt-001](/img/PT盒子-seedbox-入门指南-001.png)

  3. 选择镜像，并选择大分区，其他选择默认即可

     ![pt-008](/img/PT盒子-seedbox-入门指南-008.png))

     ![pt-009](/img/PT盒子-seedbox-入门指南-009.png)

  4. 输入登录密码，点击reinstall

### 盒子系统安装

这里使用Jerry大佬一键安装优化脚本

```bash
bash <(wget -qO- https://raw.githubusercontent.com/jerry048/Dedicated-Seedbox/main/Install.sh) -u user -p passwd -c 512 -q 4.3.9 -l v1.2.19 -b -v -3
```

```
参数说明：
-u:用户名
-p:密码
-c:qBitorrent 的缓存大小
-q:qBittorrent 版本
-l:libtorrent 版本
-b:安装autobrr
-v:安装vertex
-3:启动 BBR V3
```

安装脚本默认安装的vt是端口映射的方式，这里改成host模式。

```bash
docker ps -a
docker stop 69732193eac6
docker rm 69732193eac6
docker run -d --name vertex --restart unless-stopped --network host -v /root/vertex:/vertex -e TZ=Asia/Shanghai lswl/vertex:dev
```

安装vnstat

```bash
apt install vnstat
```

### 配置qBitorrent

#### 修改webUI

主要修改界面语言和访问端口，端口可用默认8080不修改

![pt-003](/img/PT盒子-seedbox-入门指南-003.png)

#### 修改连接的端口号默认为45000

![pt-002](/img/PT盒子-seedbox-入门指南-002.png)

### 配置vertex

访问服务器ip:3000，账号密码是上面安装脚本配置的。

#### 添加删种规则

删种规则比较多，针对不同站点有不同的规则，有需要可以留言获取

#### 添加RSS规则

rss规则同上，可以留言获取

#### 添加下载器

![pt-007](/img/PT盒子-seedbox-入门指南-007.png)

![pt-006](/img/PT盒子-seedbox-入门指南-006.png)

#### 添加RSS任务

RSS站点比较多，针对不同站点有不同的规则，有需要可以留言获取

#### 启用任务

以下是我刷流的一些数据。

![pt-005](/img/PT盒子-seedbox-入门指南-005.png)

因为最近一直再折腾，数据不是很稳定。

#### 开启数据统计

![pt-004](/img/PT盒子-seedbox-入门指南-004.png)

这样就可以在首页看到统计的数据了。

到这这台服务器已经可以进行最基本的pt刷流了，进阶和优化还需要深究。
