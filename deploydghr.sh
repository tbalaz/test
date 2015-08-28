#!/bin/bash

#remove dguk and copy dghr
rm -fR /var/ckan
cp -R /tmp/ckan /var/

#fix permissions
chown -R www-data:www-data /var/ckan/
chmod -R g+w /var/ckan/

#remove dguk and copy dghr
rm -fR /var/www
cp -R /tmp/www /var/

#fix permissions
chown -R co:www-data /var/www/drupal/
chmod -R g+w /var/www/drupal/

#remove dguk and copy dghr
rm -fR /vagrant/src
cp -R /tmp/src /vagrant/

#fix permissions
chown -R co:co /vagrant/src/

#create missing links
cd /var/www
ln -s files/ /var/www/drupal/dgud7

cd /var/www/drupal/dgu/sites/default/
ln -s /var/www/files/drupal/dgud7/files files

#set permissions
chown -R co:www-data /var/www/files/drupal/dgud7/
chmod -R g+w /var/www/files/drupal/dgud7/files/

#restore dghr demo database
mysql -D dgu -u co -ppass -e "SOURCE /tmp/dgu.dump"

#clear all caches
drush cc all

#set memory limit in php.ini
sed -i -e 's/memory_limit = 128/memory limit = 512/g' /etc/php5/apache2/php.ini

#set drupal admin password
drush upwd --password="admin12345" "admin"

#restart services
service apache2 restart
service jetty restart
