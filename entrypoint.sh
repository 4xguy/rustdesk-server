#!/bin/sh

# Set execute permissions
chmod +x /usr/bin/hbbs
chmod +x /usr/bin/hbbr

# Execute the passed command
exec "$@"