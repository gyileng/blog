# CLAUDE.md

本文件为 Claude Code (claude.ai/code) 提供在此仓库中工作的指引。

## 项目概述

基于 **Hexo 7.x** + **Butterfly 主题** 的个人博客，线上地址：<http://baiwei.space>。

## 常用命令

```bash
npm install          # 安装依赖
npm run server       # 本地预览，访问 http://localhost:4000
npm run clean        # 清理生成文件
npm run build        # 生成静态文件到 public/
npm run deploy       # 部署（_config.yml 中 type 当前未设置）

npx hexo new "文章标题"   # 在 source/_posts/ 创建新文章
```

## 项目结构

- `_config.yml` — Hexo 主配置（站点 URL、固定链接格式 `:year/:month/:day/:title/`、主题、hexo-admin 认证）
- `_config.butterfly.yml` — Butterfly 主题配置（导航栏、菜单、社交链接、外观）
- `source/_posts/` — 已发布文章（带 YAML front-matter 的 Markdown）
- `source/_drafts/` — 草稿（默认不渲染，`render_drafts: false`）
- `source/_discarded/` — 废弃/归档文章（不参与构建）
- `source/img/` — 文章和主题引用的图片资源
- `themes/butterfly/` — Butterfly 主题源码
- `docker-compose.yml` / `Dockerfile` — 容器化部署配置，用于在 NAS/服务器上运行 Hexo（host 网络模式，端口 15345）

## 文章 Front-Matter

文章使用以下结构：

```yaml
title: 文章标题
date: YYYY-MM-DD HH:mm:ss
tags:
  - tag1
categories:
  - category1
toc: true
cover: /img/cover.png
```

固定链接由 front-matter 中的 `date` 和 `title` 决定，修改任意一项都会导致已有链接失效。

## 写作规范

- 新文章标题一律使用**中文**撰写

## 提交规范

- 修改完成后，**必须先询问用户确认，再执行 git commit 和 git push**，不得自行提交

## 主题与配置说明

- 当前主题：`butterfly`（在 `_config.yml` 中配置；`_config.landscape.yml` 未启用）
- Butterfly 专属配置（代码高亮、头像、社交图标、横幅等）均在 `_config.butterfly.yml` 中
- 已安装 `hexo-admin`，可通过浏览器编辑文章；认证信息在 `_config.yml` 的 `admin:` 下
- 搜索功能由 `hexo-generator-search` 提供，输出 `search.xml`
