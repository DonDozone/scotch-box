# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
#!/bin/sh
#
# WordPress Setup Script
#
# This script will install and configure WordPress on
# an Ubuntu 14.04 droplet
export DEBIAN_FRONTEND=noninteractive;

# Update Ubuntu
apt-get update;

# Install Apache/MySQL
apt-get -y install apache2 php5 php5-mysql mysql-server mysql-client unzip;

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
for i in `seq 1 8`
do
wp_salt=$(</dev/urandom tr -dc 'a-zA-Z0-9!@#$%^&*()\-_ []{}<>~`+=,.;:/?|' | head -c 64 | sed -e 's/[\/&]/\\&/g');
sed -i "0,/put your unique phrase here/s/put your unique phrase here/$wp_salt/" /tmp/wordpress/wp-config.php;
done
cp -Rf /tmp/wordpress/* /var/www/public/.;
chown -Rf www-data:www-data /var/www/html;
a2enmod rewrite;
service apache2 restart;
SCRIPT

Vagrant.configure("2") do |config|

    config.vm.box = "scotch/box"
    config.vm.network "private_network", ip: "192.168.33.10"
    config.vm.hostname = "scotchbox"
    config.vm.synced_folder ".", "/var/www", :mount_options => ["dmode=777", "fmode=666"]

    config.vm.provision "shell", inline: $script

    # Optional NFS. Make sure to remove other synced_folder line too
    #config.vm.synced_folder ".", "/var/www", :nfs => { :mount_options => ["dmode=777","fmode=666"] }

end
