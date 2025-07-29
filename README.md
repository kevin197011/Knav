# Copyright (c) 2025 kk
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

# 运维导航系统 (KK Guide)

> 一个轻量级的运维导航管理系统，基于 Ruby Sinatra 构建，提供简洁的前端展示和强大的后台管理功能。

## ✨ 特性

- 🎯 **分类管理** - 灵活的自定义导航分类
- 🔗 **链接管理** - 完整的 CRUD 操作，支持图标、描述、排序
- 🎨 **现代化界面** - 响应式设计，支持浅色主题
- 🔍 **智能过滤** - 按分类筛选链接
- ✏️ **在线编辑** - 实时编辑分类和链接
- 🔔 **友好提示** - 统一的操作反馈系统
- 🔐 **安全认证** - 管理员权限控制
- 🐳 **容器化** - Docker 一键部署

## 🚀 快速开始

### Docker 部署 (推荐)

```bash
# 克隆项目
git clone <repository-url>
cd kk-guide

# 一键部署
./deploy.sh
```

### 本地开发

```bash
# 安装依赖
bundle install

# 启动服务
ruby app.rb

# 访问应用
open http://localhost:4567
```

## 📖 使用说明

### 默认账户
- **用户名**: `admin`
- **密码**: `admin123`

### 访问地址
- **前端展示**: http://localhost:4567/
- **管理后台**: http://localhost:4567/admin

## 🛠️ 技术栈

| 技术 | 版本 | 说明 |
|------|------|------|
| **后端** | Ruby + Sinatra | 轻量级 Web 框架 |
| **数据库** | SQLite3 | 嵌入式数据库 |
| **前端** | Tailwind CSS | 现代化样式框架 |
| **容器化** | Docker | 应用容器化 |
| **代理** | Nginx | 反向代理 (可选) |

## 📁 项目结构

```
kk-guide/
├── app.rb                 # 主应用入口
├── config/               # 配置文件
├── lib/                  # 核心代码
│   ├── controllers/      # 控制器
│   ├── models/          # 数据模型
│   ├── helpers/         # 辅助方法
│   ├── routes/          # 路由定义
│   └── views/           # 视图模板
├── docker-compose.yml   # Docker 编排
├── Dockerfile          # 容器构建
└── nginx/              # Nginx 配置
```

## 🔧 配置

### 环境变量

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `RACK_ENV` | development | 运行环境 |
| `SESSION_SECRET` | 自动生成 | 会话密钥 |
| `DATABASE_PATH` | knav.db | 数据库路径 |
| `TZ` | Asia/Shanghai | 时区设置 |

### 数据库结构

#### categories 表
| 字段 | 类型 | 说明 |
|------|------|------|
| id | INTEGER | 主键 |
| name | TEXT | 分类名称 |
| description | TEXT | 分类描述 |
| sort_order | INTEGER | 排序 |
| created_at | DATETIME | 创建时间 |

#### nav_links 表
| 字段 | 类型 | 说明 |
|------|------|------|
| id | INTEGER | 主键 |
| title | TEXT | 链接标题 |
| url | TEXT | 链接地址 |
| description | TEXT | 链接描述 |
| category_id | INTEGER | 分类ID |
| icon | TEXT | 图标 |
| sort_order | INTEGER | 排序 |
| is_active | BOOLEAN | 是否启用 |
| created_at | DATETIME | 创建时间 |

## 📚 API 接口

### 分类管理
- `GET /admin/categories` - 分类列表
- `POST /admin/categories` - 创建分类
- `PUT /admin/categories/:id` - 更新分类
- `DELETE /admin/categories/:id` - 删除分类

### 链接管理
- `GET /admin/links` - 链接列表
- `POST /admin/links` - 创建链接
- `PUT /admin/links/:id` - 更新链接
- `PUT /admin/links/:id/toggle` - 切换状态
- `DELETE /admin/links/:id` - 删除链接

## 🐳 Docker 部署

### 简化版本 (仅应用)
```bash
docker-compose -f docker-compose.simple.yml up -d
```

### 完整版本 (应用 + Nginx)
```bash
docker-compose up -d
```

## 🔒 安全建议

1. **修改默认密码** - 首次登录后立即修改管理员密码
2. **使用强密钥** - 设置强随机会话密钥
3. **配置防火墙** - 限制访问端口
4. **定期备份** - 备份数据库文件
5. **更新依赖** - 定期更新安全补丁

## 📊 监控与维护

### 健康检查
```bash
# 检查服务状态
curl http://localhost:4567/health

# 查看日志
docker-compose logs -f knav-app
```

### 数据备份
```bash
# 备份数据库
cp data/knav.db backup/navigation_$(date +%Y%m%d_%H%M%S).db

# 恢复数据库
cp backup/navigation_20231201_120000.db data/knav.db
```

## 🤝 贡献

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 📝 更新日志

### v1.0.0
- ✨ 初始版本发布
- 🎯 基础分类和链接管理
- 🎨 响应式前端界面
- 🐳 Docker 容器化支持
- 🔐 完整管理后台

## 💬 支持

- 📖 [文档](docs/)
- 🐛 [问题反馈](../../issues)
- 💡 [功能建议](../../issues)

---

**KK Guide Team** - 让运维导航更简单！ 🚀