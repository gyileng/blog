#!/bin/bash
echo "--- Starting Update: $(date) ---"
# 显式添加常用的二进制路径
export PATH=$PATH:/usr/local/bin:/usr/local/lib/node_modules/npm/bin
cd /blog

git config --global --add safe.directory /blog

# 1. 拉取代码
git pull origin master

# 2. 更新依赖
npm install

# 3. 编译并使用 PM2 重启服务
npx hexo g

# 检查进程是否已在运行，如果运行中则 restart，否则 start
if pm2 list | grep -q "hexo-blog"; then
    echo "Task exists, restarting..."
    pm2 restart "hexo-blog"
else
    echo "Task not found, starting new one..."
    pm2 start "npx hexo s -p 15345" --name "hexo-blog"
fi

echo "--- Update Complete: $(date) ---"