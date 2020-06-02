#!/bin/sh
# PHP
if [ !${rootPath} ];then
    rootPath=$(pwd)
fi
cd /usr/local/src
cp ${rootPath}/src/php-7.4.6.tar.gz ./
yum -y install sqlite-devel libxml2 libxml2-devel curl-devel
yum -y install http://rpms.remirepo.net/enterprise/7/remi/x86_64/oniguruma5-6.9.4-1.el7.remi.x86_64.rpm
yum -y install http://rpms.remirepo.net/enterprise/7/remi/x86_64/oniguruma5-devel-6.9.4-1.el7.remi.x86_64.rpm
# 建立PHP用户
groupadd php
useradd -r -g php -s /bin/false -M php
tar zxvf php-7.4.6.tar.gz && cd php-7.4.6
./buildconf
# php 配置
./configure \
--prefix=/usr/local/php \
--exec-prefix=/usr/local/php \
--bindir=/usr/local/php/bin \
--sbindir=/usr/local/php/sbin \
--includedir=/usr/local/php/include \
--libdir=/usr/local/php/lib/php \
--mandir=/usr/local/php/php/man \
--with-config-file-path=/usr/local/php/etc \
--with-mysql-sock=/var/run/mysql/mysql.sock \
--with-mhash \
--with-openssl \
--with-mysqli=shared,mysqlnd \
--with-pdo-mysql=shared,mysqlnd \
--with-iconv \
--with-zlib \
--enable-inline-optimization \
--disable-debug \
--disable-rpath \
--enable-shared \
--enable-xml \
--enable-bcmath \
--enable-shmop \
--enable-sysvsem \
--enable-mbregex \
--enable-mbstring \
--enable-ftp \
--enable-pcntl \
--enable-sockets \
--with-xmlrpc \
--enable-soap \
--without-pear \
--with-gettext \
--enable-session \
--with-curl \
--enable-opcache \
--enable-fpm \
--with-fpm-user=nginx \
--with-fpm-group=nginx \
--without-gdbm

make && make install
echo "export PATH=/usr/local/php/bin:/usr/local/php/sbin:$PATH" > /etc/profile.d/php7.sh
source /etc/profile.d/php7.sh
cp ${rootPath}/php.ini /usr/local/php/etc/php.ini
cp ${rootPath}/php-fpm.conf /usr/local/php/etc/php-fpm.conf
cp ${rootPath}/php-fpm /etc/init.d/php-fpm
chmod +x /etc/init.d/php-fpm
chkconfig --add php-fpm
chkconfig php-fpm on

cp ${rootPath}/www.conf /usr/local/php/etc/php-fpm.d/www.conf
mkdir -p /var/log/php-fpm /var/run/php-fpm
chown nginx:nginx -R /var/run/php-fpm/

mkdir -p /var/lib/php/session && chown nginx.nginx -R /var/lib/php/session
service php-fpm start