# 多阶段构建 - 构建阶段
FROM ruby:3.2-alpine AS builder

# 设置工作目录
WORKDIR /app

# 安装构建依赖
RUN apk add --no-cache \
    build-base \
    sqlite-dev \
    tzdata

# 复制Gemfile
COPY Gemfile ./

# 安装Ruby依赖
RUN bundle install --without development test

# 运行阶段
FROM ruby:3.2-alpine AS runtime

# 设置工作目录
WORKDIR /app

# 安装运行时依赖（不包含构建工具）
RUN apk add --no-cache \
    sqlite \
    tzdata \
    wget \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone

# 从构建阶段复制已安装的gems
COPY --from=builder /usr/local/bundle /usr/local/bundle

# 复制应用代码
COPY . .

# 创建数据目录
RUN mkdir -p /app/data

# 设置数据库文件路径环境变量
ENV DATABASE_PATH=/app/data/knav.db

# 暴露端口
EXPOSE 4567

# 创建非root用户
RUN addgroup -g 1000 appuser && \
    adduser -D -s /bin/sh -u 1000 -G appuser appuser && \
    chown -R appuser:appuser /app

# 切换到非root用户
USER appuser

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:4567/ || exit 1

# 启动应用
CMD ["ruby", "app.rb", "-o", "0.0.0.0"]