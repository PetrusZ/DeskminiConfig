#!/bin/bash

sudo useradd --no-create-home --system --shell /sbin/nologin samba
sudo smbpasswd -a samba

# mariadb
sudo emerge --config dev-db/mariadb
mysql> grant all privileges on *.* to 'root'@'%' identified by 'YOUR_PASSWORD';
mysql> flush privileges;

# systemd
sudo timedatectl set-ntp true
sudo timedatectl set-timezone Asia/Shanghai

sudo systemctl enable sshd
sudo systemctl enable syslog-ng@default
sudo systemctl enable cronie
sudo systemctl enable postfix
sudo systemctl enable docker
sudo systemctl enable NetworkManager
sudo systemctl enable znc
sudo systemctl enable qbittorrent-nox@$USER
sudo systemctl enable rpcbind nfs-server
sudo systemctl enable smb
sudo systemctl enable nginx
sudo systemctl enable php-fpm@7.4.service
sudo systemctl enable mariadb.service
sudo systemctl enable redis.service

# docker
docker run -p6801:80 -eARIA_SECRET=06ffa48448af4996b3da7c1df48f --name ariang -d --restart always remyj38/ariang:nginx16-alpine
docker run -d -p 9000:9000 -p 8000:8000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v /home/petrus/portainer_data:/data portainer/portainer
docker run --name myadmin -d -e PMA_HOST=$(ip route show | grep docker0 | awk '{print $9}') -e PMA_PORT=3306 -p 8081:80 --restart always phpmyadmin/phpmyadmin

sudo certbot certonly --dns-cloudflare --dns-cloudflare-credentials /etc/letsencrypt/cloudflare.ini --dns-cloudflare-propagation-seconds 60  -d *.codeplayer.org
