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
    git push
else
    echo "No local changes to push."
fi

# 2. 拉取远程更新（处理你在本地电脑提交的情况）
# 使用 rebase 可以让提交记录更整洁
git pull --rebase

# 3. 编译并使用 PM2 重启服务
echo "Checking for existing Hexo service on port 15345..."
PID=$(lsof -t -i:15345)

if [ -z "$PID" ]; then
    echo "No running service found on port 15345."
else
    echo "Found existing service (PID: $PID). Killing it..."
    kill -9 $PID
    # 给系统一点时间释放端口
    sleep 1
fi

# 2. 编译
echo "Cleaning and generating..."
npx hexo clean
npx hexo g

# 3. 启动新服务
echo "Starting Hexo service in background..."
npx hexo s -p 15345 &

echo "--- Update Complete: $(date) ---"