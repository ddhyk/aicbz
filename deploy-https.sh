#!/bin/bash

# HTTPS安全部署脚本
# 解决 AgoraRTCError WEB_SECURITY_RESTRICT 错误

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

# 函数：获取域名
get_domain() {
    if [ -z "$DOMAIN" ]; then
        read -p "请输入您的域名 (例如: example.com): " DOMAIN
        if [ -z "$DOMAIN" ]; then
            print_message "域名不能为空" $RED
            exit 1
        fi
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
    
    # 安装certbot
    if ! command_exists certbot; then
        apt install -y certbot python3-certbot-nginx
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
        ufw allow 443/tcp
        ufw --force enable
        print_message "✅ 防火墙配置完成" $GREEN
    else
        print_message "⚠️  UFW未安装，请手动开放80和443端口" $YELLOW
    fi
}

# 函数：申请SSL证书
setup_ssl() {
    print_message "🔒 申请SSL证书..." $BLUE
    
    # 检查域名是否解析到当前服务器
    SERVER_IP=$(curl -s ifconfig.me)
    DOMAIN_IP=$(dig +short $DOMAIN | tail -n1)
    
    if [ "$SERVER_IP" != "$DOMAIN_IP" ]; then
        print_message "⚠️  域名 $DOMAIN 未正确解析到当前服务器 ($SERVER_IP)" $YELLOW
        print_message "请确保域名解析正确后再运行此脚本" $YELLOW
        read -p "是否继续？(y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    # 申请证书
    certbot --nginx -d $DOMAIN --non-interactive --agree-tos --email admin@$DOMAIN
    
    if [ $? -eq 0 ]; then
        print_message "✅ SSL证书申请成功" $GREEN
    else
        print_message "❌ SSL证书申请失败" $RED
        exit 1
    fi
}

# 函数：创建Nginx配置
setup_nginx() {
    print_message "⚙️  配置Nginx..." $BLUE
    
    # 创建Nginx配置文件
    cat > "$NGINX_CONF_DIR/ai-resume" << EOF
server {
    listen 80;
    server_name $DOMAIN;
    return 301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl http2;
    server_name $DOMAIN;
    
    # SSL证书配置
    ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;
    
    # SSL安全配置
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA384;
    ssl_prefer_server_ciphers off;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    
    # 安全头配置
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Frame-Options DENY always;
    add_header X-Content-Type-Options nosniff always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    add_header X-XSS-Protection "1; mode=block" always;
    
    root $PROJECT_DIR/dist;
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
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript application/atom+xml image/svg+xml;
    
    # 日志配置
    access_log /var/log/nginx/$DOMAIN.access.log;
    error_log /var/log/nginx/$DOMAIN.error.log;
}
EOF
    
    # 启用站点
    ln -sf "$NGINX_CONF_DIR/ai-resume" "$NGINX_ENABLED_DIR/ai-resume"
    
    # 删除默认站点（如果存在）
    if [ -f "$NGINX_ENABLED_DIR/default" ]; then
        rm "$NGINX_ENABLED_DIR/default"
    fi
    
    # 测试Nginx配置
    nginx -t
    
    if [ $? -eq 0 ]; then
        print_message "✅ Nginx配置成功" $GREEN
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

# 函数：设置自动续期
setup_auto_renewal() {
    print_message "🔄 设置SSL证书自动续期..." $BLUE
    
    # 添加cron任务
    (crontab -l 2>/dev/null; echo "0 12 * * * /usr/bin/certbot renew --quiet") | crontab -
    
    print_message "✅ 自动续期设置完成" $GREEN
}

# 函数：验证部署
verify_deployment() {
    print_message "🔍 验证部署..." $BLUE
    
    # 重启Nginx
    systemctl reload nginx
    
    # 检查SSL证书
    print_message "检查SSL证书..." $YELLOW
    echo | openssl s_client -servername $DOMAIN -connect $DOMAIN:443 2>/dev/null | openssl x509 -noout -dates
    
    # 检查网站状态
    print_message "检查网站状态..." $YELLOW
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://$DOMAIN)
    
    if [ "$HTTP_STATUS" = "200" ]; then
        print_message "✅ 网站运行正常" $GREEN
    else
        print_message "⚠️  网站状态码: $HTTP_STATUS" $YELLOW
    fi
    
    print_message "🎉 部署完成！" $GREEN
    print_message "🌐 访问地址: https://$DOMAIN" $GREEN
    print_message "📊 Nginx日志: /var/log/nginx/$DOMAIN.access.log" $BLUE
    print_message "🔧 配置文件: $NGINX_CONF_DIR/ai-resume" $BLUE
}

# 主函数
main() {
    print_message "🔒 AI简历优化助手 - HTTPS安全部署" $GREEN
    print_message "解决 AgoraRTCError WEB_SECURITY_RESTRICT 错误" $YELLOW
    echo
    
    # 检查root权限
    check_root
    
    # 获取域名
    get_domain
    
    print_message "开始为域名 $DOMAIN 配置HTTPS..." $BLUE
    echo
    
    # 执行部署步骤
    install_dependencies
    setup_firewall
    setup_ssl
    setup_nginx
    deploy_project
    setup_auto_renewal
    verify_deployment
    
    print_message "" $NC
    print_message "🎊 恭喜！HTTPS部署成功完成！" $GREEN
    print_message "现在您的网站已经支持安全的HTTPS访问，" $GREEN
    print_message "不会再出现Web安全限制错误。" $GREEN
    print_message "" $NC
    print_message "📝 重要提醒：" $YELLOW
    print_message "1. SSL证书将自动续期" $YELLOW
    print_message "2. 请定期检查网站运行状态" $YELLOW
    print_message "3. 如有问题请查看Nginx日志" $YELLOW
}

# 运行主函数
main "$@"