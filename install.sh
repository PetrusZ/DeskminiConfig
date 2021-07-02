#!/bin/bash

sudo useradd --no-create-home --system --shell /sbin/nologin samba
sudo smbpasswd -a samba

# mariadb
sudo emerge --config dev-db/mariadb
mysql> grant all privileges on *.* to 'root'@'%' identified by 'YOUR_PASSWORD';
mysql> flush privileges;
# 创建gitea的数据库：
mysql> create database gitea;
# 创建gitea用户并赋予gitea数据库的权限：
mysql> grant all privileges on gitea.* to '用户名,推荐gitea'@'localhost' identified by '密码';
# 创建Nextcloud数据库
mysql> create database nextcloud;
# 创建nextcloud用户并赋予nextcloud数据库的权限：
mysql> grant all privileges on nextcloud.* to '用户名,推荐nextcloud'@'localhost' identified by '密码';

sudo newaliases

# systemd
sudo timedatectl set-ntp true
sudo timedatectl set-timezone Asia/Shanghai

sudo systemctl enable sshd
sudo systemctl enable syslog-ng@default
sudo systemctl enable cronie
sudo systemctl enable postfix
sudo systemctl enable docker
sudo systemctl enable NetworkManager
sudo systemctl enable privoxy.service
sudo systemctl enable znc
sudo systemctl enable qbittorrent-nox@$USER
sudo systemctl enable rpcbind nfs-server
sudo systemctl enable smb
sudo systemctl enable nginx
sudo systemctl enable php-fpm@7.4.service
sudo systemctl enable mariadb.service
sudo systemctl enable redis.service
sudo systemctl enable plex-media-server.service
sudo systemctl enable libvirtd.service
sudo systemctl enable libvirt-guests.service

# zfs
sudo systemctl enable zfs.target
sudo systemctl enable zfs-import-cache
sudo systemctl enable zfs-mount
sudo systemctl enable zfs-import.target

zgenhostid

# docker
# unused
docker run -d --name gitea -e USER_UID=1000 -e USER_GID=1000 -e DB_TYPE=mysql -e DB_HOST=$(ip route show | grep docker0 | awk '{print $9}'):3306 -e DB_NAME=gitea -e DB_USER=gitea -e DB_PASSWD= -p 3000:3000 -p 3022:22 -v /srv/data/gitea:/data -v /etc/timezone:/etc/timezone:ro -v /etc/localtime:/etc/localtime:ro --restart always gitea/gitea:lates
docker run -d --name webvirtcloud -p 80:80 -p 6080:6080  --label com.centurylinklabs.watchtower.enable=false --restart always retspen/webvirtcloud:1
docker run -d --name=xteve -p 34400:34400 -v /srv/data/xteve:/home/xteve/.xteve  --restart always bl0m1/xtevedocker:latest

docker run -d -p 9000:9000 -p 8000:8000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v /srv/data/config/portainer:/data portainer/portainer

docker run --name myadmin -d -e PMA_HOST=$(ip route show | grep docker0 | awk '{print $9}') -e PMA_PORT=3306 -p 8081:80 --restart always phpmyadmin/phpmyadmin

docker run -d \
    --name aria2-pro \
    --restart unless-stopped \
    --log-opt max-size=1m \
    --network host \
    -e PUID=$UID \
    -e PGID=$GID \
    -e RPC_SECRET=06ffa48448af4996b3da7c1df48f \
    -e RPC_PORT=6800 \
    -e LISTEN_PORT=6888 \
    -v /srv/data/config/aria2:/config \
    -v /srv/data/nas/downloads/aria2:/downloads \
    p3terx/aria2-pro

docker run -d \
    --name ariang \
    --restart unless-stopped \
    --log-opt max-size=1m \
    -p 6880:6880 \
    p3terx/ariang

docker run -d \
  -p 25:25 \
  -p 8082:80 \
  -p 110:110 \
  -p 143:143 \
  -p 444:443 \
  -p 587:587 \
  -p 993:993 \
  -p 995:995 \
  -e TZ=Asia/Shanghai -e DISABLE_CLAMAV=TRUE -e DISABLE_RSPAMD=TRUE \
  -v /srv/data/poste.io:/data \
  --name "mailserver" \
  -h "codeplayer.org" \
  --restart always \
  analogic/poste.io

docker run \
  -d \
  --name plex \
  -p 32400:32400/tcp \
  -p 3005:3005/tcp \
  -p 8324:8324/tcp \
  -p 32469:32469/tcp \
  -p 1900:1900/udp \
  -p 32410:32410/udp \
  -p 32412:32412/udp \
  -p 32413:32413/udp \
  -p 32414:32414/udp \
  -e TZ="Asia/Shanghai" \
  -e PLEX_CLAIM="" \
  -e ADVERTISE_IP="http://192.168.3.10:32400/" \
  -e ALLOWED_NETWORKS="192.168.3.0/24" \
  -e PLEX_UID=1000 \
  -e PLEX_GID=1000 \
  -h PlexServer \
  -v /srv/data/plex/database:/config \
  -v /srv/data/plex/transcode:/transcode \
  -v /srv/data/nas:/data \
  --device /dev/dri:/dev/dri \
  --restart always \
  plexinc/pms-docker

docker run -d \
    --name emby \
    --volume /srv/data/embyserver:/config \
    --volume /srv/data/nas:/mnt/share1 \
    --device /dev/dri:/dev/dri \
    --publish 8096:8096 \
    --publish 8920:8920 \
    --env UID=1000 \
    --env GID=100 \
    --env GIDLIST=27,28,100 \
    --restart always \
    emby/embyserver:latest

docker run -d \
  --name watchtower \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e TZ=Asia/Shanghai \
  -e WATCHTOWER_NOTIFICATIONS=email \
  -e WATCHTOWER_NOTIFICATION_EMAIL_FROM=watchtower@codeplayer.org \
  -e WATCHTOWER_NOTIFICATION_EMAIL_TO=silencly07@gmail.com \
  -e WATCHTOWER_NOTIFICATION_EMAIL_SERVER=smtp.yandex.com \
  -e WATCHTOWER_NOTIFICATION_EMAIL_SERVER_PORT=25 \
  -e WATCHTOWER_NOTIFICATION_EMAIL_SERVER_USER=watchtower@codeplayer.org \
  -e WATCHTOWER_NOTIFICATION_EMAIL_SERVER_PASSWORD= \
  -e WATCHTOWER_NOTIFICATION_EMAIL_DELAY=2 \
  --restart always \
  containrrr/watchtower --cleanup --schedule "0 0 3 * * *" \
  $(cat ~/.watchtower.list)

sudo certbot certonly --dns-cloudflare --dns-cloudflare-credentials /etc/letsencrypt/cloudflare.ini --dns-cloudflare-propagation-seconds 60  -d *.codeplayer.org
