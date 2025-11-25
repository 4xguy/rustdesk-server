# RustDesk Server - Dokploy Deployment (Single Container)
# Runs both hbbs (signal) and hbbr (relay) servers
FROM rustdesk/rustdesk-server:latest AS bins

FROM alpine:latest

# Copy binaries from official image
COPY --from=bins /usr/bin/hbbs /usr/bin/hbbs
COPY --from=bins /usr/bin/hbbr /usr/bin/hbbr

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

# Create startup script that runs both services
RUN echo '#!/bin/sh' > /start.sh && \
    echo 'cd /data' >> /start.sh && \
    echo '/usr/bin/hbbr &' >> /start.sh && \
    echo 'exec /usr/bin/hbbs -r "$RELAY"' >> /start.sh && \
    chmod +x /start.sh

CMD ["/start.sh"]
