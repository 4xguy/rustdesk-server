FROM rustdesk/rustdesk-server:latest as binaries

FROM busybox:stable
ARG S6_OVERLAY_VERSION=3.2.0.0
ARG S6_ARCH=x86_64

# Copy HBBS binary from the official image
COPY --from=binaries /usr/bin/hbbs /usr/bin/hbbs

# Add S6 overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_ARCH}.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz && \
    tar -C / -Jxpf /tmp/s6-overlay-${S6_ARCH}.tar.xz && \
    rm /tmp/s6-overlay*.tar.xz && \
    ln -s /run /var/run

# Create necessary directories
RUN mkdir -p /etc/s6-overlay/s6-rc.d/hbbs \
    mkdir -p /data && \
    chmod 777 /data

# Add service definition
COPY --chmod=755 <<-"EOF" /etc/s6-overlay/s6-rc.d/hbbs/run
#!/command/with-contenv sh
echo "Starting HBBS service..."
cd /data
exec 2>&1
RELAY_SERVER=${RELAY_SERVER:rustdesk-hbbr.railway.internal}
echo "Connecting to relay server: ${RELAY_SERVER}:21117"
exec /usr/bin/hbbs -r ${RELAY_SERVER}:21117
EOF

# Configure s6 service
RUN mkdir -p /etc/s6-overlay/s6-rc.d/user/contents.d && \
    touch /etc/s6-overlay/s6-rc.d/user/contents.d/hbbs && \
    mkdir -p /etc/s6-overlay/s6-rc.d/hbbs/dependencies.d && \
    echo "longrun" > /etc/s6-overlay/s6-rc.d/hbbs/type

EXPOSE 21115 21116 21116/udp 21118
WORKDIR /data

# Set S6 environment variables
ENV S6_KEEP_ENV=1
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2
ENV S6_LOGGING=1

ENTRYPOINT ["/init"]