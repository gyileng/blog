# 使用 Node 18 作为基础镜像
FROM node:18-slim

# 更换为阿里云镜像源 (针对 Debian 11/12)
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list

# 安装 Git 和 Webhook 工具
RUN apt-get update \
	&& apt-get install -y git webhook \
	&& apt-get clean \
	&& echo "Asia/Shanghai" > /etc/timezone \
    && npm config set registry https://registry.npm.taobao.org \
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