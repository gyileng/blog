#!/bin/bash
# 赋予脚本执行权限（保险起见）
chmod +x /blog/deploy.sh

# 1. 启动时执行第一次部署
/blog/deploy.sh

# 2. 启动 Webhook 并在前台运行
exec webhook -verbose -hooks=/blog/hooks.json -hotreload