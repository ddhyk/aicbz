#!/bin/bash

# 宝塔面板专用部署脚本
# 适用于宝塔面板环境的AI简历优化助手部署

set -e  # 遇到错误时退出

echo "🚀 宝塔面板 - AI简历优化助手部署脚本"
echo "================================================"

# 检查是否在宝塔环境中
if [ ! -d "/www" ]; then
    echo "⚠️  警告: 未检测到宝塔面板环境，但仍可继续部署"
fi

# 检查Node.js
if ! command -v node &> /dev/null; then
    echo "❌ 错误: Node.js未安装"
    echo "请在宝塔面板中安装Node.js (推荐版本16.x或18.x)"
    exit 1
fi

echo "✅ Node.js版本: $(node -v)"
echo "✅ npm版本: $(npm -v)"

# 显示当前目录
echo "📁 当前目录: $(pwd)"

# 备份旧的构建文件
if [ -d "dist" ]; then
    BACKUP_NAME="dist.backup.$(date +%Y%m%d_%H%M%S)"
    echo "📦 备份旧版本到: $BACKUP_NAME"
    mv dist "$BACKUP_NAME"
fi

# 清理npm缓存和旧依赖
echo "🧹 清理缓存和旧依赖..."
npm cache clean --force 2>/dev/null || echo "缓存清理完成"
rm -rf node_modules package-lock.json 2>/dev/null || echo "旧依赖清理完成"

# 检查npm源
echo "🔍 检查npm源配置..."
REGISTRY=$(npm config get registry)
echo "当前npm源: $REGISTRY"

if [[ $REGISTRY == *"npmmirror"* ]]; then
    echo "🔄 检测到国内镜像源，如遇问题将自动切换"
fi

# 安装依赖
echo "📦 安装项目依赖..."
if ! npm install; then
    echo "⚠️  使用当前源安装失败，尝试切换到官方源..."
    npm config set registry https://registry.npmjs.org/
    echo "🔄 重新安装依赖..."
    npm install
fi

echo "✅ 依赖安装完成"

# 构建项目
echo "🔨 构建生产版本..."
if ! npm run build; then
    echo "❌ 构建失败，请检查代码是否有错误"
    exit 1
fi

echo "✅ 构建完成"

# 检查构建结果
if [ ! -d "dist" ]; then
    echo "❌ 构建失败: dist目录不存在"
    exit 1
fi

# 设置文件权限（如果在宝塔环境中）
if [ -d "/www" ]; then
    echo "🔐 设置文件权限..."
    chown -R www:www dist/ 2>/dev/null || echo "权限设置跳过（可能需要root权限）"
    chmod -R 755 dist/ 2>/dev/null || echo "权限设置跳过"
fi

# 显示部署信息
echo ""
echo "🎉 部署完成！"
echo "================================================"
echo "📁 构建文件位置: $(pwd)/dist"
echo "📊 构建文件大小: $(du -sh dist 2>/dev/null || echo '未知')"
echo ""
echo "📋 宝塔面板配置步骤:"
echo "1. 在宝塔面板中创建网站"
echo "2. 将网站根目录设置为: $(pwd)/dist"
echo "3. 配置Nginx支持Vue Router (参考宝塔面板部署指南.md)"
echo "4. 申请SSL证书 (推荐)"
echo ""
echo "🔧 Nginx配置要点:"
echo "   - 根目录: $(pwd)/dist"
echo "   - 添加: try_files \$uri \$uri/ /index.html;"
echo "   - 启用Gzip压缩"
echo ""
echo "📖 详细说明请查看: 宝塔面板部署指南.md"
echo "🌐 部署完成后访问你的域名即可查看网站"

# 提供快速nginx配置
echo ""
read -p "是否生成Nginx配置文件? (y/n): " generate_nginx

if [[ $generate_nginx == "y" || $generate_nginx == "Y" ]]; then
    read -p "请输入你的域名 (例: example.com): " domain_name
    
    if [ -n "$domain_name" ]; then
        cat > nginx-site.conf << EOF
server {
    listen 80;
    server_name $domain_name;
    root $(pwd)/dist;
    index index.html;
    
    # Vue Router 历史模式支持
    location / {
        try_files \$uri \$uri/ /index.html;
    }
    
    # 静态资源缓存
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)\$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # Gzip压缩
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
}
EOF
        echo "✅ Nginx配置已生成: nginx-site.conf"
        echo "请将此配置复制到宝塔面板的网站配置中"
    fi
fi

echo ""
echo "🚀 部署完成！祝你使用愉快！"