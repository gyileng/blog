#!/bin/bash
echo "--- Starting Update: $(date) ---"
# 显式添加常用的二进制路径
export PATH=$PATH:/usr/local/bin:/usr/local/lib/node_modules/npm/bin
cd /blog

git config --global --add safe.directory /blog
git config --global user.email "zxrgyobj@gmail.com"
git config --global user.name "NAS-Hexo-Admin"

git add . && git commit -m "update from hexo-admin" && git push

# 1. 只有当有文件变动时才提交（防止报错中断）
if [[ -n $(git status -s) ]]; then
    echo "Detected local changes from hexo-admin, pushing to GitHub..."
    git add .
    git commit -m "update from hexo-admin at $(date)"
    git push origin master
else
    echo "No local changes to push."
fi

# 2. 拉取远程更新（处理你在本地电脑提交的情况）
# 使用 rebase 可以让提交记录更整洁
git pull --rebase origin master

# 3. 编译并使用 PM2 重启服务
npx hexo clean
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