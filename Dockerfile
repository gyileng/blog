FROM node:18-slim

# 或者使用一个“兼容性”写法（同时尝试修改新旧两种路径，忽略错误）
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list.d/debian.sources || true && \
    sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list || true

RUN apt-get update && \
    apt-get install -y git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 修复 Git 权限报错
RUN git config --global --add safe.directory /blog

WORKDIR /blog
EXPOSE 15345

CMD ["sh", "-c", "npm install && npx hexo server -p 15345"]