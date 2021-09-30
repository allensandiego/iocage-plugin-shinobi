pkg update -f
pkg upgrade -f
pkg install -y git
pkg install -y ffmpeg
pkg install -y x264
pkg install -y x265 
pkg install -y node
pkg install -y npm
pkg install -y mysql57-server
pkg install -y mysql57-client
cd /home
git clone https://gitlab.com/Shinobi-Systems/Shinobi.git shinobi
cd shinobi
sysrc mysql_enable=YES
service mysql-server start
mysql -h localhost -u root -e "source sql/user.sql"
mysql -h localhost -u root -e "source sql/framework.sql"
npm install -g npm
npm install --unsafe-perm
npm install -g pm2@latest
cp conf.sample.json conf.json
cp super.sample.json super.json
pm2 start camera.js
pm2 start cron.js
pm2 save
pm2 list
pm2 startup rcd