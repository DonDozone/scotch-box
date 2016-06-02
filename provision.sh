#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive;

# Update Ubuntu
apt-get update;

# Install Apache/MySQL
apt-get -y install apache2 php5 php5-mysql mysql-server mysql-client unzip php5-dev;

# Install and configure xdebug
mkdir /var/log/xdebug
chown www-data:www-data /var/log/xdebug
sudo pecl install xdebug

echo '' >> /etc/php5/apache2/php.ini
echo ';;;;;;;;;;;;;;;;;;;;;;;;;;' >> /etc/php5/apache2/php.ini
echo '; Added to enable Xdebug ;' >> /etc/php5/apache2/php.ini
echo ';;;;;;;;;;;;;;;;;;;;;;;;;;' >> /etc/php5/apache2/php.ini
echo '' >> /etc/php5/apache2/php.ini
echo 'zend_extension="'$(find / -name 'xdebug.so' 2> /dev/null)'"' >> /etc/php5/apache2/php.ini
echo 'xdebug.default_enable = 1' >> /etc/php5/apache2/php.ini
echo 'xdebug.idekey = "vagrant"' >> /etc/php5/apache2/php.ini
echo 'xdebug.remote_enable = 1' >> /etc/php5/apache2/php.ini
echo 'xdebug.remote_autostart = 0' >> /etc/php5/apache2/php.ini
echo 'xdebug.remote_port = 9000' >> /etc/php5/apache2/php.ini
echo 'xdebug.remote_handler=dbgp' >> /etc/php5/apache2/php.ini
echo 'xdebug.remote_log="/var/log/xdebug/xdebug.log"' >> /etc/php5/apache2/php.ini
echo 'xdebug.remote_host=10.0.2.2 ; IDE-Environments IP, from vagrant box.' >> /etc/php5/apache2/php.ini

# Download and uncompress WordPress
wget https://wordpress.org/latest.zip -O /tmp/wordpress.zip;
cd /tmp/;
unzip /tmp/wordpress.zip;
# Set up database user
/usr/bin/mysqladmin -u root -proot -h localhost create wordpress;

# Configure WordPress
cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php;
sed -i "s/'DB_NAME', 'database_name_here'/'DB_NAME', 'wordpress'/g" /tmp/wordpress/wp-config.php;
sed -i "s/'DB_USER', 'username_here'/'DB_USER', 'root'/g" /tmp/wordpress/wp-config.php;
sed -i "s/'DB_PASSWORD', 'password_here'/'DB_PASSWORD', 'root'/g" /tmp/wordpress/wp-config.php;

cp -Rf /tmp/wordpress/* /var/www/public/.;
chown -Rf www-data:www-data /var/www/html;
a2enmod rewrite;
service apache2 restart;