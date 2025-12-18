title: 在群晖NAS上使用Docker搭建Hexo自动化发布系统
toc: true
tags:
  - 群辉
  - NAS
categories:
  - 教程
date: 2025-12-18 14:01:00
cover:
---

# 在群晖 NAS 上使用 Docker 搭建 Hexo 自动化发布系统

本文将记录如何利用群晖 NAS，通过 Docker 容器化技术搭建一个高效的 Hexo 博客系统。该系统支持 **Git 自动触发更新**、**PM2 进程守护**、**Host 网络模式**以及 **Cloudflare Tunnel 内网穿透**。

## 🚀 系统架构

- **容器化环境**：Node.js 18 + Git + Webhook + PM2。
- **网络模式**：Host 模式（共享宿主机 IP，方便访问本地代理）。
- **自动化流**：本地 Push $\rightarrow$ GitHub Webhook $\rightarrow$ NAS Webhook 监听 $\rightarrow$ 自动执行 `deploy.sh` $\rightarrow$ PM2 重启 Hexo。
- **外部访问**：Cloudflare Tunnel 提供域名访问及 SSL 加密。

------

## 🛠️ 环境准备

### 1. 宿主机 Git 安装

在群晖“套件中心”搜索并安装 **Git Server**。安装后在终端验证：

Bash

```
git --version
```

### 2. 目录初始化

在 NAS 上克隆你的博客仓库：

Bash

```
cd /volume1/docker
git clone https://github.com/你的用户名/仓库名.git my-blog
cd my-blog
```

------

## 📦 核心配置清单

在项目根目录下创建以下四个核心文件：

### 1. Dockerfile

该文件定义了全能编译环境。

Dockerfile

```
FROM node:18-slim

# 适配 Debian 12 换源 (阿里云)
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list.d/debian.sources && \
    sed -i 's/security.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list.d/debian.sources

# 安装必要工具
RUN apt-get update && \
    apt-get install -y git webhook psmisc procps && \
    apt-get clean

# 安装 PM2 进程守护
RUN npm config set registry https://registry.npmmirror.com && \
    npm install -g pm2

# 修复 Git 目录权限限制
RUN git config --global --add safe.directory /blog

WORKDIR /blog
EXPOSE 9000 15345

CMD ["/blog/entrypoint.sh"]
```

### 2. docker-compose.yml

使用 Host 模式以便轻松调用本地代理。

YAML

```
version: '3'
services:
  hexo-standalone:
    build: .
    container_name: hexo_standalone
    network_mode: host
    volumes:
      - .:/blog
      - /root/.ssh:/root/.ssh  # 映射 SSH 密钥以实现免密 Pull
    restart: always
```

### 3. deploy.sh (自动化脚本)

负责更新、编译、重启。

Bash

```
#!/bin/bash
export PATH=$PATH:/usr/local/bin:/usr/local/lib/node_modules/npm/bin
cd /blog

# 1. 更新代码及依赖
git pull origin master
npm install

# 2. 编译
npx hexo g

# 3. 使用 PM2 守护进程 (端口 15345)
if pm2 list | grep -q "hexo-blog"; then
    pm2 restart "hexo-blog"
else
    pm2 start "npx hexo s -p 15345" --name "hexo-blog"
fi
```

### 4. hooks.json

定义 Webhook 触发规则。

JSON

```
[
  {
    "id": "redeploy-blog",
    "execute-command": "/blog/deploy.sh",
    "command-working-directory": "/blog",
    "response-message": "Deployment started...",
    "trigger-rule": {
      "match": {
        "type": "payload-hash-sha256",
        "secret": "your_secure_token",
        "parameter": {
          "source": "header",
          "name": "X-Hub-Signature-256"
        }
      }
    }
  }
]
```

------

## 🔗 自动化与穿透配置

### 1. GitHub Webhook 设置

在仓库设置中添加 Webhook：

- **Payload URL**: `https://webhook.yourdomain.com/hooks/redeploy-blog`
- **Content type**: `application/json`
- **Secret**: 与 `hooks.json` 中保持一致。

### 2. Cloudflare Tunnel 配置

在 Zero Trust 控制台添加公共主机名映射：

- **博客**: `blog.yourdomain.com` $\rightarrow$ `http://127.0.0.1:15345`
- **钩子**: `webhook.yourdomain.com` $\rightarrow$ `http://127.0.0.1:9000`

------

## ⚠️ 常见避坑指南

1. **权限报错**：确保 `deploy.sh` 和 `entrypoint.sh` 在宿主机执行过 `chmod +x`。
2. **Git 信任目录**：容器内 Git 权限严格，务必执行 `git config --global --add safe.directory /blog`。
3. **只读文件系统**：如果 `known_hosts` 报错，请确保映射的 `.ssh` 目录具有写权限，或者先在宿主机手动完成初次 SSH 握手。

------

现在，每当你完成一篇文章并 `git push` 后，你的群晖 NAS 就会在几秒钟内自动完成部署，保持博客永远是最新的状态！
