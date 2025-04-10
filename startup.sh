#!/bin/bash
apt-get update
apt-get install -y docker.io unzip

docker run -d \
  --name valheim-server \
  -p 2456-2458:2456-2458/udp \
  -e SERVER_NAME="MeuServidorValheim" \
  -e WORLD_NAME="MundoValheim" \
  -e SERVER_PASS="123senha" \
  -v /root/valheim:/config \
  --restart always \
  lloesche/valheim-server
