#!/bin/sh

# Download Shinobi repository
git clone https://gitlab.com/Shinobi-Systems/Shinobi.git /usr/local/shinobi

# Change directory to Shinobi
cd /usr/local/shinobi

# Enable mysql service
sysrc mysql_enable=YES

# Start mysql service
service mysql-server start

# Get mysql root default password
set mysql_root_pass=`tail -n +2 /root/.mysql_secret`

# Create Shinobi user in mysql
mysql -h localhost -u root -e -p$mysql_root_pass "source sql/user.sql"

# Install Shinobi framework in mysql
mysql -h localhost -u root -e -p$mysql_root_pass "source sql/framework.sql"

# Install npm components
npm install -g npm
npm install --unsafe-perm
npm install -g pm2@latest

# Copy default config files
cp conf.sample.json conf.json
cp super.sample.json super.json

# Start camera and cron applications
pm2 start camera.js
pm2 start cron.js
pm2 save
pm2 list
pm2 startup rcd

echo ""
echo ""
echo "Download mobile app for android on https://peek.allensandiego.com/"
echo "Disclaimer: Peek for Android is not in anyway connected to Shinobi or its developer/s."
echo ""
echo ""

