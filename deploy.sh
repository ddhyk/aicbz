#!/bin/bash

# AI简历优化助手部署脚本
# 用于构建和部署Vue项目

set -e  # 遇到错误时退出

echo "🚀 开始部署AI简历优化助手..."

# 检查Node.js是否安装
if ! command -v node &> /dev/null; then
    echo "❌ 错误: Node.js未安装，请先安装Node.js"
    exit 1
fi

# 检查npm是否安装
if ! command -v npm &> /dev/null; then
    echo "❌ 错误: npm未安装，请先安装npm"
    exit 1
fi

echo "📦 安装依赖..."
npm install

echo "🔨 构建项目..."
npm run build

# 检查构建是否成功
if [ ! -d "dist" ]; then
    echo "❌ 构建失败: dist目录不存在"
    exit 1
fi

echo "✅ 构建完成!"

# 启动服务器的选项
echo ""
echo "🌐 选择启动方式:"
echo "1. 使用Python简单HTTP服务器 (推荐用于测试)"
echo "2. 使用Node.js serve包 (推荐用于生产)"
echo "3. 使用nginx (需要手动配置)"
echo "4. 仅构建，不启动服务器"

read -p "请选择 (1-4): " choice

case $choice in
    1)
        echo "🐍 使用Python启动服务器..."
        cd dist
        if command -v python3 &> /dev/null; then
            echo "📡 服务器启动在: http://localhost:8000"
            python3 -m http.server 8000
        elif command -v python &> /dev/null; then
            echo "📡 服务器启动在: http://localhost:8000"
            python -m SimpleHTTPServer 8000
        else
            echo "❌ Python未安装，无法启动服务器"
            exit 1
        fi
        ;;
    2)
        echo "📦 安装serve包..."
        npm install -g serve
        echo "🚀 使用serve启动服务器..."
        echo "📡 服务器启动在: http://localhost:3000"
        serve -s dist -l 3000
        ;;
    3)
        echo "📋 Nginx配置示例:"
        echo "server {"
        echo "    listen 80;"
        echo "    server_name your-domain.com;"
        echo "    root $(pwd)/dist;"
        echo "    index index.html;"
        echo ""
        echo "    location / {"
        echo "        try_files \$uri \$uri/ /index.html;"
        echo "    }"
        echo "}"
        echo ""
        echo "请将以上配置添加到nginx配置文件中，然后重启nginx"
        ;;
    4)
        echo "✅ 构建完成，dist目录已准备好部署"
        echo "📁 构建文件位置: $(pwd)/dist"
        ;;
    *)
        echo "❌ 无效选择"
        exit 1
        ;;
esac

echo ""
echo "🎉 部署完成!"
echo "📁 项目文件位置: $(pwd)/dist"
echo "💡 提示: 如需修改代码，请重新运行此脚本"