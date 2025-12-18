#!/bin/bash
cd /blog
git pull origin main  # 拉取最新代码
npm install           # 更新依赖
npx hexo g            # 生成静态文件
npx hexo s &
echo "Update complete at $(date)"