#!/bin/bash

# Instalar ferramentas necessárias
apt-get update
apt-get install -y net-tools curl unzip docker.io

# Salvar o script de monitoramento
cat << 'EOF' > /opt/monitoring/send_player_count.sh
#!/bin/bash
INSTANCE_NAME="valheim-server"
PROJECT_ID="server-valheim-iac-v2"
ZONE="southamerica-east1-a"

player_count=$(docker logs valheim-server 2>&1 | grep "Connections" | tail -n 1 | grep -oP 'Connections \K[0-9]+')

gcloud beta monitoring metrics write custom.googleapis.com/valheim/players_online \
  --project="$PROJECT_ID" \
  --value="$player_count" \
  --zone="$ZONE" \
  --format=json \
  --labels=instance_name="$INSTANCE_NAME"
EOF

chmod +x /opt/monitoring/send_player_count.sh

# Adicionar cronjob no root
echo "*/5 * * * * root /opt/monitoring/send_player_count.sh" > /etc/cron.d/valheim-player-monitor
