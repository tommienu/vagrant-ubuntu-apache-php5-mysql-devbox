#Update
apt-get -y update

#Apache2
apt-get -y install apache2
rm -rf /var/www
ln -fs /vagrant /var/www

#MySql
YourPassword="tommie"

debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password password $YourPassword"
debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password_again password $YourPassword"
apt-get -y install mysql-server
apt-get -y install libapache2-mod-auth-mysql php5-mysql 
mysql_install_db
/usr/bin/mysql_secure_installation<<EOF
$YourPassword
n
Y
Y
Y
Y
EOF

#PHP
apt-get -y install php5 libapache2-mod-php5 php5-mcrypt

#phpmyadmin
apt-get -y install phpmyadmin
sudo ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf.d/phpmyadmin.conf

service apache2 restart

#Xdebug
apt-get -y install php5-dev php-pear
apt-get -y install make
pecl install xdebug
xdebugsolocation="$(find / -name 'xdebug.so' 2> /dev/null)"
echo "
[xdebug]
zend_extension=\"$xdebugsolocation\"
xdebug.default_enable=1
xdebug.remote_enable=1
xdebug.remote_handler=dbgp
xdebug.remote_host=192.168.33.10
;xdebug.remote_connect_back=1
xdebug.remote_port=9000
xdebug.remote_autostart=0
xdebug.remote_log=/tmp/php5-xdebug.log
" | sudo tee /etc/php5/apache2/php.ini -a

service apache2 restart
