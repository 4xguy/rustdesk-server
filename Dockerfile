FROM rustdesk/rustdesk-server:latest

# Create a shell script to execute commands
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]