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
sudo systemctl enable smartd.service
sudo systemctl enable --now cockpit.socket
sudo systemctl enable --now pmlogger.service

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

docker run -d -p 9000:9000 -p 8000:8000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v /srv/data/config/portainer:/data portainer/portainer-ce

docker run --name myadmin -d -e PMA_HOST=$(ip route show | grep docker0 | awk '{print $9}') -e PMA_PORT=3306 -p 8081:80 --restart always phpmyadmin/phpmyadmin

docker run -d \
    --name aria2-pro \
    --restart always \
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
    --restart always \
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
  -p 1901:1900/udp \
  -p 32410:32410/udp \
  -p 32412:32412/udp \
  -p 32413:32413/udp \
  -p 32414:32414/udp \
  -e TZ="Asia/Shanghai" \
  -e PLEX_CLAIM="claim-jf8Vndd6fhTqzz8ufWmC" \
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
    --volume /srv/data/nas:/media \
    --device /dev/dri:/dev/dri \
    --publish 8096:8096 \
    --publish 8920:8920 \
    --env UID=1000 \
    --env GID=100 \
    --env GIDLIST=27,28,100 \
    --restart always \
    emby/embyserver:latest

docker run -d \
 --name jellyfin \
 --user 1000:1000 \
 -e TZ="Asia/Shanghai" \
 -e JELLYFIN_PublishedServerUrl=192.168.3.10 \
 -p 8096:8096 \
 -p 8920:8920 \
 -p 7359:7359/udp \
 -p 1900:1900/udp \
 -v /srv/data/jellyfin/config:/config \
 -v /srv/data/jellyfin/cache:/cache \
 -v /srv/data/nas:/data:ro \
 --device /dev/dri:/dev/dri \
 --net=host \
 --restart=always \
 jellyfin/jellyfin:latest

docker run -d \
  --name elasticsearch \
  -p 9200:9200 \
  -p 9300:9300 \
  #-e "discovery.type=single-node" \
  -e ES_JAVA_OPTS="-Xms256m -Xmx2048m" \
  -v /srv/data/elasticsearch/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml \
  -v /srv/data/elasticsearch/data:/usr/share/elasticsearch/data \
  #-v /srv/data/elasticsearch/plugins:/usr/share/elasticsearch/plugins \
  --restart=always \
  elasticsearch:7.16.3
docker run -d --name kibana --link=elasticsearch:test -p 5601:5601 --restart=always kibana:7.16.3
 
docker run -d --name=netdata \
  -p 19999:19999 \
  -v netdataconfig:/etc/netdata \
  -v netdatalib:/var/lib/netdata \
  -v netdatacache:/var/cache/netdata \
  -v /etc/passwd:/host/etc/passwd:ro \
  -v /etc/group:/host/etc/group:ro \
  -v /proc:/host/proc:ro \
  -v /sys:/host/sys:ro \
  -v /etc/os-release:/host/etc/os-release:ro \
  --hostname=deskmini \
  --restart=always \
  --cap-add SYS_PTRACE \
  --security-opt apparmor=unconfined \
  -e NETDATA_CLAIM_TOKEN= \
  -e NETDATA_CLAIM_URL=https://app.netdata.cloud \
  netdata/netdata

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
  containrrr/watchtower:latest-dev --cleanup --schedule "0 0 3 * * *" \
  $(cat ~/.watchtower.list)

docker run -d \
  --name postgres \
  -p 5432:5432 \
  -e POSTGRES_USER=root \
  -e POSTGRES_PASSWORD="" \
  -v /srv/data/postgres:/var/lib/postgresql/data \
  --restart=always \
  postgres:latest

docker run -d \
  --name code-server \
  -p 8083:8080 \
  -v "$HOME/.config:/home/coder/.config" \
  -v "$HOME/.local/share:/home/coder/.local/share" \
  -v "$HOME/Project:/home/coder/project" \
  -u "$(id -u):$(id -g)" \
  -e PASSWORD="" \
  -e "DOCKER_USER=$USER" \
  --restart=always \
  codercom/code-server:latest

docker run -d --name ssl-exporter -p 9219:9219 --restart=always ribbybibby/ssl-exporter:latest

docker run -d --name libvirt-exporter -p 9177:9177 -v /var/run/libvirt:/var/run/libvirt --restart=always alekseizakharov/libvirt-exporter:latest

docker run -d \
  --name cadvisor \
  -p 8085:8080 \
  -v /:/rootfs:ro \
  -v /var/run:/var/run:rw \
  -v /sys:/sys:ro \
  -v /var/lib/docker/:/var/lib/docker:ro \
  -v /dev/disk/:/dev/disk:ro \
  --restart=always \
  gcr.io/cadvisor/cadvisor:latest --docker_only=true --housekeeping_interval=10s


docker run -d \
  --name qbittorrent-exporter \
  -e QBITTORRENT_USERNAME= \
  -e QBITTORRENT_PASSWORD= \
  -e QBITTORRENT_BASE_URL=http://192.168.3.10:8082 \
  -p 17871:17871 \
  --restart=always \
  caseyscarborough/qbittorrent-exporter:latest

docker run -d \
  --name twitter-media-scraper \
  -v /srv/data/nas/adult/twitter-media-scraper/out:/cmd/out \
  -v /srv/data/nas/adult/twitter-media-scraper/configs:/cmd/configs \
  -v /etc/timezone:/etc/timezone:ro \
  -v /etc/localtime:/etc/localtime:ro \
  --restart=always \
  patrickz07/twitter-media-scraper:latest

docker run -d -p 8090:8080 -p 8086:8086 \
  -v /srv/data/scrutiny/config:/opt/scrutiny/config \
  -v /srv/data/scrutiny/influxdb2:/opt/scrutiny/influxdb \
  -v /run/udev:/run/udev:ro \
  --cap-add SYS_RAWIO \
  --cap-add SYS_ADMIN \
  --device=/dev/sda \
  --device=/dev/sdb \
  --device=/dev/nvme0 \
  --name scrutiny \
  --restart=always \
  ghcr.io/analogj/scrutiny:master-omnibus

#sudo certbot certonly --dns-cloudflare --dns-cloudflare-credentials /etc/letsencrypt/cloudflare.ini --dns-cloudflare-propagation-seconds 60  -d *.codeplayer.org
sudo acme.sh --issue --dns dns_cf -d *.codeplayer.org
sudo acme.sh --install-cert -d codeplayer.org --key-file /etc/nginx/key.pem --fullchain-file /etc/nginx/fullchain.pem --reloadcmd "systemctl reload nginx"
