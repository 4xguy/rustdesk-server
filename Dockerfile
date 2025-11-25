# RustDesk Server - Dokploy Deployment
# Base: rustdesk/rustdesk-server with s6-overlay managing hbbs + hbbr services
FROM rustdesk/rustdesk-server:latest

# Configuration
ENV RELAY=rustdesk.icvida.com \
    ENCRYPTED_ONLY=0

# Ports:
# 21115 - hbbs TCP (NAT type test)
# 21116 - hbbs TCP/UDP (ID registration & heartbeat)
# 21117 - hbbr TCP (relay)
# 21118 - hbbr TCP (relay)
# 21119 - hbbs TCP (Web console support)
EXPOSE 21115 \
       21116 \
       21116/udp \
       21117 \
       21118 \
       21119

# Data persistence (keys, logs, configs)
VOLUME /data

# Healthcheck - verify both services running via s6
HEALTHCHECK --interval=10s --timeout=5s --start-period=5s --retries=3 \
    CMD /usr/bin/healthcheck.sh

WORKDIR /data

# s6-overlay entrypoint (already configured in base)
# Starts hbbs with: -r $RELAY [-k _]
# Starts hbbr with: [-k _]
