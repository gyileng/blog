# 使用 Node 18 作为基础镜像
FROM node:18-alpine

# 安装 Git 和 Webhook 工具
RUN apt-get update \
	&& apt-get install -y git webhook \
	&& apt-get clean \
	&& echo "Asia/Shanghai" > /etc/timezone \
    && echo "https://mirrors.ustc.edu.cn/alpine/v3.9/main/" > /etc/apk/repositories  \
    && npm config set registry https://registry.npm.taobao.org \
    && apk add --no-cache git \
    && npm install hexo-cli -g \    
    && chmod 777 /blog/deploy.sh

# 设置工作目录
WORKDIR /blog

# 暴露 Webhook 监听端口
EXPOSE 4000
EXPOSE 9000

# 启动 Webhook 服务
# -verbose 开启详细日志，方便调试
# -hotreload 允许修改 hooks.json 后自动生效
CMD ["webhook", "-verbose", "-hooks=/blog/hooks.json", "-hotreload"]