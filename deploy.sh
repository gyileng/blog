#!/bin/bash
echo "--- Starting Update: $(date) ---"
cd /blog

git config --global --add safe.directory /blog

# 1. 拉取代码
git pull origin main

# 2. 更新依赖
npm install

# 3. 编译并使用 PM2 重启服务
npx hexo g
# --replace 表示如果存在同名任务则替换，保持端口为 15345
pm2 start "npx hexo s -p 15345" --name "hexo-blog" --replace

echo "--- Update Complete: $(date) ---"