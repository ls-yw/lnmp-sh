#!/bin/sh
#NGINX
if [ !${rootPath} ];then
    rootPath=$(pwd)
fi
yum -y install libxml2-devel libxslt-devel perl-ExtUtils-Embed
cd /usr/local/src
cp ${rootPath}/src/nginx-1.18.0.tar.gz ./
groupadd nginx
useradd -r -g nginx -s /bin/false -M nginx
tar zxvf nginx-1.18.0.tar.gz
cd nginx-1.18.0
cp ${rootPath}/src/pcre-8.44.tar.gz ./
tar zxvf pcre-8.44.tar.gz
cp ${rootPath}/src/zlib-1.2.11.tar.gz ./
tar zxvf zlib-1.2.11.tar.gz
mkdir -p /var/tmp/nginx/{client,proxy,fastcgi,uwsgi,scgi}
mkdir -p /var/run/nginx
# ngixn makefile
./configure \
 --prefix=/usr/local/nginx \
 --sbin-path=/usr/local/nginx/bin/nginx \
 --conf-path=/usr/local/nginx/conf/nginx.conf \
 --error-log-path=/var/log/nginx/error.log \
 --http-log-path=/var/log/nginx/access.log \
 --pid-path=/var/run/nginx/nginx.pid  \
 --lock-path=/var/lock/nginx.lock \
 --user=nginx \
 --group=nginx \
 --with-http_ssl_module \
 --with-http_flv_module \
 --with-http_realip_module \
 --with-http_addition_module \
 --with-http_xslt_module \
 --with-http_stub_status_module \
 --with-http_sub_module \
 --with-http_random_index_module \
 --with-http_degradation_module \
 --with-http_secure_link_module \
 --with-http_gzip_static_module \
 --with-http_perl_module \
 --with-pcre=pcre-8.44 \
 --with-zlib=zlib-1.2.11 \
 --with-debug \
 --with-file-aio \
 --with-mail \
 --with-mail_ssl_module \
 --http-client-body-temp-path=/var/tmp/nginx/client/ \
 --http-proxy-temp-path=/var/tmp/nginx/proxy/ \
 --http-fastcgi-temp-path=/var/tmp/nginx/fcgi/ \
 --http-uwsgi-temp-path=/var/tmp/nginx/uwsgi \
 --http-scgi-temp-path=/var/tmp/nginx/scgi \
 --with-stream \
 --with-ld-opt="-Wl,-E"
make && make install
echo "export PATH=$PATH:/usr/local/nginx/bin/" > /etc/profile.d/nginx.sh
source /etc/profile.d/nginx.sh
chown nginx.nginx -R /usr/local/nginx/
mv ${rootPath}/nginx/nginx /etc/init.d/
chmod +x /etc/init.d/nginx
chkconfig --add nginx
chkconfig nginx on

mkdir /usr/local/nginx/conf/vhosts
cp -f ${rootPath}/nginx/nginx.conf /usr/local/nginx/conf/
cp ${rootPath}/nginx/test.conf /usr/local/nginx/conf/vhosts

service nginx start
ps -ef | grep nginx