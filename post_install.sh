#!/bin/sh

# Download Shinobi repository and copy default config files
git clone https://gitlab.com/Shinobi-Systems/Shinobi.git /usr/local/shinobi

# Enable mysql service
sysrc mysql_enable=YES 

# Start mysql service
service mysql-server start

# Configure mysql database
mysql -h localhost -u root -e -p`tail -n +2 /root/.mysql_secret` --connect-expired-password <<EOF
alter user 'root'@'localhost' identified by '`tail -n +2 /root/.mysql_secret`;
source /usr/local/shinobi/sql/user.sql
source /usr/local/shinobi/sql/framework.sql
EOF

echo "Done installing..."
