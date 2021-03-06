#!/bin/sh
# 目标服务器 aliyun centos 7.7
# 环境 PHP 7.4.6  Nginx 1.18.0
rootPath=$(pwd)
mkdir /usr/local/src
mkdir -p /data/html/www
mkdir -p /data/logs/nginx
yum -y install lrzsz gcc gcc-c++ openssl openssl-devel

chmod +x ${rootPath}/nginx/nginx.sh ${rootPath}/php/php.sh ${rootPath}/mysql/mysql.sh

source ${rootPath}/nginx/nginx.sh
source ${rootPath}/php/php.sh
source ${rootPath}/mysql/mysql.sh

