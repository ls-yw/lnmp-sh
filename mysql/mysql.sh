#!/bin/sh
# mysql
cd /usr/local/src
cp ${rootPath}/src/mysql-boost-5.7.30.tar.gz ./
cp ${rootPath}/src/boost_1_59_0.tar.gz ./
tar zxvf boost_1_59_0.tar.gz
cp -r boost_1_59_0 /usr/local/boost
yum -y install ncurses ncurses-devel bison libgcrypt perl make cmake
groupadd mysql
useradd -r -g mysql -s /bin/false -M mysql
tar zxvf mysql-boost-5.7.30.tar.gz
cd mysql-5.7.30/
mkdir -p /usr/local/mysql /usr/local/mysql/{data,logs,pids}
chown -R mysql:mysql /usr/local/mysql
cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DMYSQL_DATADIR=/usr/local/mysql/data \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DMYSQL_TCP_PORT=3306 \
-DMYSQL_USER=mysql \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_ARCHIVE_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITH_MEMORY_STORAGE_ENGINE=1 \
-DENABLE_DOWNLOADS=1 \
-DDOWNLOAD_BOOST=1 \
-DWITH_BOOST=/usr/local/boost
make && make install
echo "export PATH=/usr/local/mysql/bin:/usr/local/mysql/lib:$PATH" > /etc/profile.d/mysql.sh
source /etc/profile.d/mysql.sh
cp support-files/mysql.server /etc/init.d/mysqld
chmod a+x /etc/init.d/mysqld
chkconfig --add mysqld
chkconfig mysqld on
chkconfig --list | grep mysqld
mysqld --initialize-insecure --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data
cp ${rootPath}/my.cnf /etc/
touch /usr/local/mysql/logs/mysqld.log
touch /usr/local/mysql/pids/mysqld.pid
chown mysql.mysql -R /usr/local/mysql/
service mysqld start
