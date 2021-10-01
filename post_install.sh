#!/bin/sh

# Download Shinobi repository and copy default config files
git clone https://gitlab.com/Shinobi-Systems/Shinobi.git /usr/local/shinobi

# Enable mysql service
sysrc mysql_enable=YES 

# Start mysql service
service mysql-server start

# Configure mysql database
echo "mysql -h localhost -u root -e -p`tail -n +2 /root/.mysql_secret` --connect-expired-password <<EOF
alter user 'root'@'localhost' identified by '`tail -n +2 /root/.mysql_secret`;
source /usr/local/shinobi/sql/user.sql
source /usr/local/shinobi/sql/framework.sql
EOF
" >> /tmp/mysql_init.sh

cat /tmp/mysql_init.sh

sh /tmp/mysql_init.sh

echo "Done installing..."
