#!/bin/bash

# 快速启动脚本
# 用于开发环境快速启动项目

echo "🚀 启动AI简历优化助手开发服务器..."

# 检查依赖是否安装
if [ ! -d "node_modules" ]; then
    echo "📦 安装依赖..."
    npm install
fi

echo "🌐 启动开发服务器..."
echo "📡 服务器将在 http://localhost:5173 启动"
npm run dev