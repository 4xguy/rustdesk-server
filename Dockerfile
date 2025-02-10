FROM alpine:latest

# Copy binaries from rustdesk image
COPY --from=rustdesk/rustdesk-server:latest /usr/bin/hbbs /usr/bin/hbbs
COPY --from=rustdesk/rustdesk-server:latest /usr/bin/hbbr /usr/bin/hbbr

# Set execute permissions
RUN chmod +x /usr/bin/hbbs && \
    chmod +x /usr/bin/hbbr

# Create data directory
RUN mkdir -p /root

VOLUME /root