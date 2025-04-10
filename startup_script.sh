#!/bin/bash

USER_HOME="/home/valheim"
DOCKER_VOLUME="/opt/valheim-data"
SERVER_CONTAINER_NAME="valheim-server"

apt-get update -y && apt-get upgrade -y
apt-get install -y docker.io ufw curl

useradd -m -d $USER_HOME -s /usr/sbin/nologin valheim
usermod -aG docker valheim
systemctl enable docker
systemctl start docker

mkdir -p $DOCKER_VOLUME
chown valheim:valheim $DOCKER_VOLUME

docker run -d \
  --name $SERVER_CONTAINER_NAME \
  -p 2456-2458:2456-2458/udp \
  -v $DOCKER_VOLUME:/config \
  -e SERVER_NAME="${server_name}" \
  -e WORLD_NAME="${world_name}" \
  -e SERVER_PASS="${server_pass}" \
  -e TZ="America/Sao_Paulo" \
  --restart unless-stopped \
  lloesche/valheim-server

ufw default deny incoming
ufw allow 22/tcp
ufw allow 2456:2458/udp
ufw --force enable

curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
bash add-google-cloud-ops-agent-repo.sh --also-install

mkdir -p /opt/monitoring

cat << 'EOF' > /opt/monitoring/send_player_count.sh
#!/bin/bash
PLAYER_COUNT=$(netstat -anp | grep 2456 | grep ESTABLISHED | wc -l)
gcloud monitoring metrics write custom.googleapis.com/valheim/players_online \
  --project="${project_id}" \
  --value="$PLAYER_COUNT" \
  --zone="${zone}" \
  --labels=instance_name="${instance_name}"
EOF

chmod +x /opt/monitoring/send_player_count.sh
(crontab -l 2>/dev/null; echo "*/5 * * * * /opt/monitoring/send_player_count.sh") | crontab -

echo "Valheim server provisionado com sucesso em $(date)" >> /var/log/valheim_startup.log
