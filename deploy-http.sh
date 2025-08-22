#!/bin/bash

# HTTP部署脚本（强制HTTP，不使用HTTPS）
# 注意：此配置存在安全风险，仅用于开发或内网环境

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置变量
DOMAIN=""
PROJECT_DIR="/www/wwwroot/ai-resume"
NGINX_CONF_DIR="/etc/nginx/sites-available"
NGINX_ENABLED_DIR="/etc/nginx/sites-enabled"

# 函数：打印彩色消息
print_message() {
    echo -e "${2}${1}${NC}"
}

# 函数：检查命令是否存在
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 函数：检查是否为root用户
check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_message "此脚本需要root权限运行" $RED
        print_message "请使用: sudo $0" $YELLOW
        exit 1
    fi
}

# 函数：获取域名或IP
get_domain() {
    if [ -z "$DOMAIN" ]; then
        read -p "请输入您的域名或IP地址 (例如: example.com 或 192.168.1.100): " DOMAIN
        if [ -z "$DOMAIN" ]; then
            print_message "域名/IP不能为空" $RED
            exit 1
        fi
    fi
}

# 函数：显示安全警告
show_security_warning() {
    print_message "" $NC
    print_message "⚠️  ⚠️  ⚠️  安全警告 ⚠️  ⚠️  ⚠️" $RED
    print_message "" $NC
    print_message "您选择了HTTP部署，这存在以下安全风险：" $YELLOW
    print_message "1. 数据传输不加密，可能被窃听" $YELLOW
    print_message "2. 无法防止中间人攻击" $YELLOW
    print_message "3. 现代浏览器可能限制某些功能" $YELLOW
    print_message "4. 搜索引擎排名可能受影响" $YELLOW
    print_message "" $NC
    print_message "建议仅在以下情况使用HTTP：" $BLUE
    print_message "• 开发测试环境" $BLUE
    print_message "• 内网环境" $BLUE
    print_message "• 临时演示" $BLUE
    print_message "" $NC
    
    read -p "您确定要继续使用HTTP部署吗？(y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_message "部署已取消" $YELLOW
        exit 0
    fi
}

# 函数：安装必要软件
install_dependencies() {
    print_message "📦 安装必要软件..." $BLUE
    
    # 更新包列表
    apt update
    
    # 安装nginx
    if ! command_exists nginx; then
        apt install -y nginx
    fi
    
    # 安装Node.js (如果不存在)
    if ! command_exists node; then
        curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
        apt install -y nodejs
    fi
    
    print_message "✅ 依赖安装完成" $GREEN
}

# 函数：配置防火墙
setup_firewall() {
    print_message "🔥 配置防火墙..." $BLUE
    
    if command_exists ufw; then
        ufw allow 22/tcp
        ufw allow 80/tcp
        ufw --force enable
        print_message "✅ 防火墙配置完成（仅开放80端口）" $GREEN
    else
        print_message "⚠️  UFW未安装，请手动开放80端口" $YELLOW
    fi
}

# 函数：创建HTTP Nginx配置
setup_nginx_http() {
    print_message "⚙️  配置Nginx（HTTP模式）..." $BLUE
    
    # 创建Nginx配置文件
    cat > "$NGINX_CONF_DIR/ai-resume-http" << EOF
server {
    listen 80;
    server_name $DOMAIN;
    
    root $PROJECT_DIR/dist;
    index index.html;
    
    # 添加安全头（HTTP环境下的基本安全）
    add_header X-Frame-Options DENY always;
    add_header X-Content-Type-Options nosniff always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    add_header X-XSS-Protection "1; mode=block" always;
    
    # 禁用服务器版本信息
    server_tokens off;
    
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
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript application/atom+xml image/svg+xml;
    
    # 限制请求大小
    client_max_body_size 10M;
    
    # 日志配置
    access_log /var/log/nginx/$DOMAIN.access.log;
    error_log /var/log/nginx/$DOMAIN.error.log;
    
    # 禁止访问敏感文件
    location ~ /\. {
        deny all;
    }
    
    location ~ \.(env|config|ini|log|sh)\$ {
        deny all;
    }
}
EOF
    
    # 启用站点
    ln -sf "$NGINX_CONF_DIR/ai-resume-http" "$NGINX_ENABLED_DIR/ai-resume-http"
    
    # 删除默认站点（如果存在）
    if [ -f "$NGINX_ENABLED_DIR/default" ]; then
        rm "$NGINX_ENABLED_DIR/default"
    fi
    
    # 删除可能存在的HTTPS配置
    if [ -f "$NGINX_ENABLED_DIR/ai-resume" ]; then
        rm "$NGINX_ENABLED_DIR/ai-resume"
    fi
    
    # 测试Nginx配置
    nginx -t
    
    if [ $? -eq 0 ]; then
        print_message "✅ Nginx HTTP配置成功" $GREEN
    else
        print_message "❌ Nginx配置错误" $RED
        exit 1
    fi
}

# 函数：部署项目
deploy_project() {
    print_message "🚀 部署项目..." $BLUE
    
    # 创建项目目录
    mkdir -p $PROJECT_DIR
    cd $PROJECT_DIR
    
    # 备份旧版本
    if [ -d "dist" ]; then
        mv dist dist.backup.$(date +%Y%m%d_%H%M%S)
    fi
    
    # 清理缓存
    npm cache clean --force
    rm -rf node_modules package-lock.json
    
    # 安装依赖
    npm install
    
    # 构建项目
    npm run build
    
    # 设置权限
    chown -R www-data:www-data $PROJECT_DIR
    chmod -R 755 $PROJECT_DIR
    
    print_message "✅ 项目部署完成" $GREEN
}

# 函数：创建浏览器兼容性处理
create_compatibility_script() {
    print_message "🔧 创建浏览器兼容性处理..." $BLUE
    
    # 在dist目录中添加兼容性脚本
    cat > "$PROJECT_DIR/dist/http-compatibility.js" << 'EOF'
// HTTP环境兼容性处理脚本
(function() {
    // 检查是否为HTTP环境
    if (location.protocol === 'http:') {
        console.warn('当前运行在HTTP环境，某些功能可能受限');
        
        // 禁用某些需要HTTPS的功能
        if (window.navigator && window.navigator.serviceWorker) {
            // 在HTTP环境下禁用Service Worker
            delete window.navigator.serviceWorker;
        }
        
        // 添加HTTP环境提示
        var httpWarning = document.createElement('div');
        httpWarning.style.cssText = `
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            background: #ff9800;
            color: white;
            text-align: center;
            padding: 8px;
            font-size: 14px;
            z-index: 10000;
            box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        `;
        httpWarning.innerHTML = '⚠️ 当前使用HTTP连接，建议使用HTTPS以获得更好的安全性';
        
        // 添加关闭按钮
        var closeBtn = document.createElement('span');
        closeBtn.innerHTML = ' ✕';
        closeBtn.style.cssText = 'cursor: pointer; margin-left: 10px; font-weight: bold;';
        closeBtn.onclick = function() {
            httpWarning.remove();
        };
        httpWarning.appendChild(closeBtn);
        
        // 页面加载完成后显示警告
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', function() {
                document.body.appendChild(httpWarning);
            });
        } else {
            document.body.appendChild(httpWarning);
        }
        
        // 5秒后自动隐藏
        setTimeout(function() {
            if (httpWarning.parentNode) {
                httpWarning.remove();
            }
        }, 5000);
    }
})();
EOF
    
    # 在index.html中引入兼容性脚本
    if [ -f "$PROJECT_DIR/dist/index.html" ]; then
        sed -i 's|</head>|  <script src="/http-compatibility.js"></script>\n</head>|' "$PROJECT_DIR/dist/index.html"
    fi
    
    print_message "✅ 兼容性处理完成" $GREEN
}

# 函数：验证部署
verify_deployment() {
    print_message "🔍 验证部署..." $BLUE
    
    # 重启Nginx
    systemctl reload nginx
    
    # 检查网站状态
    print_message "检查网站状态..." $YELLOW
    sleep 2
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://$DOMAIN)
    
    if [ "$HTTP_STATUS" = "200" ]; then
        print_message "✅ 网站运行正常" $GREEN
    else
        print_message "⚠️  网站状态码: $HTTP_STATUS" $YELLOW
    fi
    
    print_message "🎉 HTTP部署完成！" $GREEN
    print_message "🌐 访问地址: http://$DOMAIN" $GREEN
    print_message "📊 Nginx日志: /var/log/nginx/$DOMAIN.access.log" $BLUE
    print_message "🔧 配置文件: $NGINX_CONF_DIR/ai-resume-http" $BLUE
}

# 函数：显示后续建议
show_recommendations() {
    print_message "" $NC
    print_message "📋 后续建议：" $BLUE
    print_message "" $NC
    print_message "1. 🔒 生产环境强烈建议使用HTTPS" $YELLOW
    print_message "   运行: sudo ./deploy-https.sh" $YELLOW
    print_message "" $NC
    print_message "2. 🛡️  定期更新系统和依赖" $YELLOW
    print_message "   sudo apt update && sudo apt upgrade" $YELLOW
    print_message "" $NC
    print_message "3. 📊 监控网站访问日志" $YELLOW
    print_message "   tail -f /var/log/nginx/$DOMAIN.access.log" $YELLOW
    print_message "" $NC
    print_message "4. 🔧 如需修改配置" $YELLOW
    print_message "   编辑: $NGINX_CONF_DIR/ai-resume-http" $YELLOW
    print_message "   重载: sudo systemctl reload nginx" $YELLOW
    print_message "" $NC
}

# 主函数
main() {
    print_message "🌐 AI简历优化助手 - HTTP部署" $GREEN
    print_message "强制HTTP模式（不推荐用于生产环境）" $YELLOW
    echo
    
    # 检查root权限
    check_root
    
    # 显示安全警告
    show_security_warning
    
    # 获取域名
    get_domain
    
    print_message "开始为 $DOMAIN 配置HTTP服务..." $BLUE
    echo
    
    # 执行部署步骤
    install_dependencies
    setup_firewall
    setup_nginx_http
    deploy_project
    create_compatibility_script
    verify_deployment
    show_recommendations
    
    print_message "" $NC
    print_message "⚠️  重要提醒：" $RED
    print_message "当前使用HTTP部署，存在安全风险" $RED
    print_message "建议仅用于开发测试或内网环境" $RED
    print_message "生产环境请使用HTTPS部署" $RED
}

# 运行主函数
main "$@"