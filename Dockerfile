FROM rustdesk/rustdesk-server:latest

EXPOSE 21115 21116 21116/udp 21117 21118 21119

CMD ["sh", "-c", "./hbbs -r 127.0.0.1:21117 & ./hbbr"]
