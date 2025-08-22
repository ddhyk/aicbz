# AI简历优化助手 - 部署指南

## 快速开始

### 开发环境启动

```bash
# 方式1: 使用快速启动脚本
./start.sh

# 方式2: 手动启动
npm install
npm run dev
```

### 生产环境部署

```bash
# 使用部署脚本（推荐）
./deploy.sh

# 手动部署
npm install
npm run build
```

## 部署选项

### 1. Python HTTP服务器（测试用）

```bash
# 构建项目
npm run build

# 启动服务器
cd dist
python3 -m http.server 8000
# 或者 python -m SimpleHTTPServer 8000 (Python 2)
```

访问地址: http://localhost:8000

### 2. Node.js serve包（推荐）

```bash
# 安装serve
npm install -g serve

# 构建并启动
npm run build
serve -s dist -l 3000
```

访问地址: http://localhost:3000

### 3. Nginx部署

1. 构建项目：
```bash
npm run build
```

2. 配置Nginx：
```nginx
server {
    listen 80;
    server_name your-domain.com;
    root /path/to/your/project/dist;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # 静态资源缓存
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

3. 重启Nginx：
```bash
sudo nginx -t
sudo systemctl reload nginx
```

### 4. Docker部署

创建 `Dockerfile`：
```dockerfile
# 构建阶段
FROM node:18-alpine as build-stage
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build

# 生产阶段
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

构建和运行：
```bash
docker build -t ai-resume-optimizer .
docker run -p 80:80 ai-resume-optimizer
```

## 环境要求

- Node.js >= 16.0.0
- npm >= 8.0.0
- 现代浏览器支持 ES6+

## 项目结构

```
├── dist/                 # 构建输出目录
├── src/                  # 源代码
│   ├── components/       # Vue组件
│   ├── views/           # 页面组件
│   ├── assets/          # 静态资源
│   └── router/          # 路由配置
├── deploy.sh            # 部署脚本
├── start.sh             # 开发启动脚本
├── package.json         # 项目配置
└── vite.config.js       # Vite配置
```

## 常见问题

### 1. 端口被占用

```bash
# 查看端口占用
lsof -i :3000

# 杀死进程
kill -9 <PID>
```

### 2. 权限问题

```bash
# 给脚本添加执行权限
chmod +x deploy.sh
chmod +x start.sh
```

### 3. 依赖安装失败

```bash
# 清除缓存
npm cache clean --force

# 删除node_modules重新安装
rm -rf node_modules package-lock.json
npm install
```

### 4. 构建失败

检查以下几点：
- Node.js版本是否符合要求
- 依赖是否正确安装
- 代码是否有语法错误

## 性能优化建议

1. **启用Gzip压缩**
2. **配置CDN**
3. **使用HTTP/2**
4. **启用浏览器缓存**
5. **图片优化**

## 监控和日志

建议在生产环境中配置：
- 错误监控（如Sentry）
- 性能监控
- 访问日志分析

## 安全建议

1. 使用HTTPS
2. 配置安全头
3. 定期更新依赖
4. 配置防火墙

---

如有问题，请查看项目文档或联系开发团队。