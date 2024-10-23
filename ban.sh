#!/bin/bash

# 确保以管理员身份运行脚本
if [[ $EUID -ne 0 ]]; then
   echo "请以管理员身份运行此脚本" 
   exit 1
fi

# 启用错误检查
set -e

# 安装依赖
apt-get update
apt-get install dnsmasq -y

# 备份原始配置文件
cp /etc/dnsmasq.conf /etc/dnsmasq.conf_bak

# 停止 dnsmasq 服务
systemctl stop --now dnsmasq

# 配置 dnsmasq
cat > /etc/dnsmasq.conf << EOF
# 严格按照 resolv-file 文件中的顺序从上到下进行 DNS 解析, 直到第一个成功解析成功为止
strict-order

# 监听的 IP 地址
listen-address=127.0.0.1

# 设置缓存大小
cache-size=10240

# 泛域名解析，访问指定域名都会被解析到 127.0.0.1
address=/youtube.com/127.0.0.1
address=/whatsapp.com/127.0.0.1
address=/line.me/127.0.0.1
address=/facebook.com/127.0.0.1
address=/instagram.com/127.0.0.1
address=/youtubee.com/127.0.0.1
address=/91porn.com/127.0.0.1
address=/pornhub.com/127.0.0.1
address=/t66y.com/127.0.0.1
address=/twitter.com/127.0.0.1
address=/x.com/127.0.0.1
EOF

# 配置 resolv.conf
cat > /etc/resolv.conf << EOF
nameserver 127.0.0.1
nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 1.1.1.1
EOF

# 启用并启动 dnsmasq 服务
systemctl enable --now dnsmasq

# 再次配置 resolv.conf
cat > /etc/resolv.conf << EOF
nameserver 127.0.0.1
nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 1.1.1.1
EOF
