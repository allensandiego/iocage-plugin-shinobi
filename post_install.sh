#!/bin/sh

# Download Shinobi repository and copy default config files
git clone https://gitlab.com/Shinobi-Systems/Shinobi.git -b master /usr/local/shinobi

# Change directory to shinobi
cd /usr/local/shinobi

# Create default config files
cp conf.sample.json conf.json
cp super.sample.json super.json

# Enable mysql service
sysrc mysql_enable=YES 

# Start mysql service
service mysql-server start

# Setup Shinobi mysql database
mysql -e "source sql/user.sql" || true
mysql -e "source sql/framework.sql" || true

# Install npm components
npm install -g npm
npm install -g pm2@latest

# Start shinobi
pm2 start camera.js 
pm2 start cron.js 
pm2 save 
pm2 list 
pm2 startup rcd

echo "Getting Started" >> /root/PLUGIN_INFO
echo "" >> /root/PLUGIN_INFO
echo "- Login with the default superuser account and create a new user at http://$IOCAGE_PLUGIN_IP:8080/super" >> /root/PLUGIN_INFO
echo "" >> /root/PLUGIN_INFO
echo "  username : admin@shinobi.video" >> /root/PLUGIN_INFO
echo "  password : admin" >> /root/PLUGIN_INFO
echo "" >> /root/PLUGIN_INFO
echo "- After creating a new user, go to http://$IOCAGE_PLUGIN_IP:8080/ and login with the new user credentials" >> /root/PLUGIN_INFO
echo "- For Shinobi documentation, go to https://shinobi.video/docs/" >> /root/PLUGIN_INFO
echo "" >> /root/PLUGIN_INFO
echo "P.S." >> /root/PLUGIN_INFO
echo "" >> /root/PLUGIN_INFO
echo "Check out the unofficial android app for Shinobi at https://peek.allensandiego.com/" >> /root/PLUGIN_INFO
echo "" >> /root/PLUGIN_INFO