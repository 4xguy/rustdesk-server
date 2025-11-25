# RustDesk Server - Dokploy Deployment
# Runs both hbbs (signal) and hbbr (relay) servers
FROM rustdesk/rustdesk-server:latest

# Configuration
ENV RELAY=rustdesk.icvida.com
ENV ENCRYPTED_ONLY=0

# Ports:
# 21115 - hbbs TCP (NAT type test)
# 21116 - hbbs TCP/UDP (ID registration & heartbeat)
# 21117 - hbbr TCP (relay)
# 21118 - hbbr TCP (relay websocket)
# 21119 - hbbs TCP (Web client)
EXPOSE 21115 21116 21116/udp 21117 21118 21119

# Data persistence (keys, db)
VOLUME /data
WORKDIR /data

# Start both services using s6-overlay init system
ENTRYPOINT ["/init"]
