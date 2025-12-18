FROM node:18-slim

# 或者使用一个“兼容性”写法（同时尝试修改新旧两种路径，忽略错误）
 RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list.d/debian.sources || true && \
     sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list || true

RUN apt-get update && \
    apt-get install -y git webhook psmisc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 全局安装 PM2
RUN npm config set registry https://registry.npmmirror.com && \
    npm install -g pm2

# 修复 Git 权限报错
RUN git config --global --add safe.directory /blog

WORKDIR /blog
EXPOSE 9000 15345

CMD ["/blog/entrypoint.sh"]