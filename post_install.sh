#!/bin/sh

# Enable and start mysql service
sysrc mysql_enable=YES && service mysql-server start

# Download Shinobi repository and copy default config files
git clone https://gitlab.com/Shinobi-Systems/Shinobi.git /usr/local/shinobi && cd /usr/local/shinobi && cp conf.sample.json conf.json && cp super.sample.json super.json

if [ -e "/root/.mysql_secret" ] ; then
  # Change mysql root password
  mysql -h localhost -u root -e -p`tail -n +2 /root/.mysql_secret` --connect-expired-password <<EOF
  alter user 'root'@'localhost' identified by '`tail -n +2 /root/.mysql_secret`;
  EOF
  
  # Create Shinobi user in mysql
  mysql -h localhost -u root -e -p`tail -n +2 /root/.mysql_secret` -e "source sql/user.sql"

  # Install Shinobi framework in mysql
  mysql -h localhost -u root -e -p`tail -n +2 /root/.mysql_secret` -e "source sql/framework.sql"
fi

# Install npm components and start shinobi
npm install -g -save npm pm2@3.0.0 --unsafe-perm >> /tmp/npm-install.log && pm2 start camera.js cron.js && pm2 save && pm2 list && pm2 startup rcd

