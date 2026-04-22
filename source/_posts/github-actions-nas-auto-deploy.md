---
title: 用 GitHub Actions + Cloudflare Tunnel 实现博客自动部署到 NAS
date: 2026-04-22 13:43:21
tags:
  - GitHub Actions
  - Cloudflare Tunnel
  - NAS
  - Docker
  - CI/CD
categories:
  - 折腾记录
toc: true
---

博客部署在家里的 NAS 上，每次写完文章都要手动 SSH 进去 `git pull` 再重启容器，麻烦。折腾了一下午，终于用 GitHub Actions + Cloudflare Tunnel 实现了 push 即部署。记录一下踩过的坑。

<!-- more -->

## 环境说明

- 博客：Hexo 7.x + Butterfly 主题，跑在 NAS 的 Docker 容器里
- NAS：群晖，没有公网 IP，通过 **Cloudflare Tunnel** 穿透，SSH 地址为 `ssh.baiwei.site`
- 目标：push 到 GitHub master 分支后，自动 SSH 进 NAS 执行 `git pull` + 重启容器

## 最终 Workflow

先放结论，完整可用的 `.github/workflows/deploy.yml`：

```yaml
name: Deploy to NAS

on:
  push:
    branches:
      - master

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Install cloudflared
        run: |
          curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o cloudflared.deb
          sudo dpkg -i cloudflared.deb

      - name: Setup SSH
        run: |
          set -eu
          mkdir -p ~/.ssh
          echo "${{ secrets.NAS_SSH_KEY }}" > ~/.ssh/id_rsa
          chmod 600 ~/.ssh/id_rsa
          cat >> ~/.ssh/config <<EOF
          Host nas
            HostName ssh.baiwei.site
            StrictHostKeyChecking no
            User baiwei
            ProxyCommand cloudflared access ssh --hostname %h
            IdentityFile ~/.ssh/id_rsa
            BatchMode yes
          EOF

      - name: Deploy
        run: |
          ssh -T nas '
            set -e
            export PATH=$PATH:/usr/local/git/bin:/usr/bin:/usr/local/bin
            sudo git config --global --add safe.directory /volume1/homes/baiwei/documents/blog
            cd /volume1/homes/baiwei/documents/blog
            sudo git pull
            sudo docker-compose restart
          '
```

GitHub Secret 只需要一个：`NAS_SSH_KEY`，填 NAS 上生成的 SSH 私钥内容。

## 踩坑过程

### 坑一：cloudflared 命令用错了

最开始以为 Cloudflare Tunnel 不需要 cloudflared 客户端，直接 `ssh baiwei@ssh.baiwei.site` 结果报：

```
ssh: connect to host ssh.baiwei.site port 22: Network is unreachable
```

Cloudflare Tunnel 并不会把 TCP 22 端口直接暴露出来，必须通过 cloudflared 代理。

然后尝试了 `cloudflared access tcp` 和 `cloudflared access ssh` 两种方式，最终 `cloudflared access ssh --hostname %h` 作为 ProxyCommand 是正确的，可以成功建立连接。

### 坑二：NAS 自动封 IP

前几次 SSH 失败（密钥还没配好），NAS 的自动封锁策略把 GitHub Actions runner 的 IP `172.17.0.5` 直接封掉了，之后每次都返回 `Connection closed by UNKNOWN port 65535`，以为是配置问题，排查了很久。

解决：去群晖「安全性」→「自动封锁」里手动解封该 IP，之后恢复正常。

### 坑三：SSH 环境 PATH 不完整

SSH 非交互式登录时，环境变量和本地登录不一样，git 不在默认 PATH 里：

```
sh: line 3: git: command not found
```

在部署脚本里手动补充路径解决：

```bash
export PATH=$PATH:/usr/local/git/bin:/usr/bin:/usr/local/bin
```

### 坑四：git safe.directory 报错

```
fatal: detected dubious ownership in repository at '/volume1/homes/baiwei/documents/blog'
```

git 2.35.2 之后加了所有者检查，目录所有者和当前用户不一致时会拒绝操作。加一行配置：

```bash
sudo git config --global --add safe.directory /volume1/homes/baiwei/documents/blog
```

### 坑五：baiwei 用户没有仓库权限

```
warning: unable to access '.git/config': Permission denied
```

博客目录是 root 所有，baiwei 用户没有写权限。解决方案是给 baiwei 配置免密 sudo：

```bash
sudo sh -c 'echo "baiwei ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'
```

之后 git pull 和 docker-compose restart 都加上 `sudo` 前缀即可。

## 小结

整个流程打通后，写完文章 `git push`，一分钟内博客自动更新。主要难点集中在 Cloudflare Tunnel 的连接方式和群晖的权限体系上，希望对有类似环境的人有所参考。
