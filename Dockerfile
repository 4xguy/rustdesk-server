FROM rustdesk/rustdesk-server:latest as binaries

FROM busybox:stable
ARG S6_OVERLAY_VERSION=3.2.0.0
ARG S6_ARCH=x86_64

# Copy RustDesk binaries from the official image
COPY --from=binaries /usr/bin/hbbs /usr/bin/hbbs
COPY --from=binaries /usr/bin/hbbr /usr/bin/hbbr

# Add S6 overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_ARCH}.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz && \
    tar -C / -Jxpf /tmp/s6-overlay-${S6_ARCH}.tar.xz && \
    rm /tmp/s6-overlay*.tar.xz && \
    ln -s /run /var/run

# Create necessary directories
RUN mkdir -p /etc/s6-overlay/s6-rc.d/hbbs \
    mkdir -p /etc/s6-overlay/s6-rc.d/hbbr \
    mkdir -p /data && \
    chmod 777 /data

# Add service definitions
COPY --chmod=755 <<-"EOF" /etc/s6-overlay/s6-rc.d/hbbs/run
#!/command/with-contenv sh
cd /data
exec /usr/bin/hbbs -r localhost:21117
EOF

COPY --chmod=755 <<-"EOF" /etc/s6-overlay/s6-rc.d/hbbr/run
#!/command/with-contenv sh
cd /data
exec /usr/bin/hbbr
EOF

# Configure services
RUN mkdir -p /etc/s6-overlay/s6-rc.d/user/contents.d && \
    touch /etc/s6-overlay/s6-rc.d/user/contents.d/hbbs && \
    touch /etc/s6-overlay/s6-rc.d/user/contents.d/hbbr

EXPOSE 21115 21116 21116/udp 21117 21118 21119
WORKDIR /data

ENTRYPOINT ["/init"]