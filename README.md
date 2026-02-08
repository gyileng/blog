# BaiWeiのBlog（Hexo）

个人博客源码仓库，基于 **Hexo 7.x** + **Butterfly 主题**。

- 在线地址：<http://baiwei.space>
- 文章目录：[`source/_posts`](./source/_posts)

## 站点导航（页面入口）

> 以下链接为站点页面（需要站点部署后可访问）

- 首页：<http://baiwei.space/>
- 分类：<http://baiwei.space/categories/>
- 标签：<http://baiwei.space/tags/>
- 友链：<http://baiwei.space/link/>

## 文章导航（按主题）

> 说明：本站 `permalink` 配置为 `:year/:month/:day/:title/`，因此文章链接依赖 front-matter 中的 `date` 与 `title`。
> 如果你修改了文章标题或日期，链接也会随之变化。

### 数据结构 / 算法

- 数据结构之数组与链表（2024-09-09）
- 数据结构之栈与队列
- 数据结构之哈希表
- 数据结构之二叉树

### 面试

- 面试总结-1
- 面试总结-数据结构篇（2024-09-06）

### NAS / 黑群晖 / Docker / 折腾

- 在群晖NAS上使用Docker搭建Hexo自动化发布系统
- 黑群晖折腾记-1-硬件选购

### Mac / Linux

- 记录Macos使用PD18安装Ubuntu22
- Mac必备软件推荐-一

### 工具 / 下载

- 安装rclone挂载pikpak作为影视盘
- PT盒子-seedbox-入门指南

### 生活 / 旅行 / 料理

- 日本自由行攻略
- 空气炸锅蜜汁烤鸡腿

### 运动 / 马拉松

- 2026马拉松计划

## 写作与本地预览

### 常用命令（npm scripts）

```bash
npm install
npm run server   # 本地预览 http://localhost:4000
npm run clean
npm run build    # 生成到 public/
npm run deploy
```

### 新建文章

```bash
npx hexo new "文章标题"
```

文章文件默认生成在 `source/_posts/`。

## 目录速览

```text
source/
  _posts/        # 正式文章
  _drafts/       # 草稿
  _discarded/    # 废弃/归档（不参与构建）
  categories/    # 分类页
  tags/          # 标签页
  link/          # 友链页
  img/           # 图片资源
themes/butterfly # Butterfly 主题
```

## 部署与自动化（可选）

- `deploy.sh`：用于在服务器/NAS 环境中自动 pull、生成并重启（默认端口 15345）
- `docker-compose.yml`：提供容器化运行方式（`hexo-standalone`）

---

### 待完善

- [ ] 将上方“文章导航”补全为可点击的站点链接（需要读取每篇文章的 date/title 生成 permalink）
- [ ] 按 `categories/tags` 自动分组并生成目录（可写脚本自动更新 README）
