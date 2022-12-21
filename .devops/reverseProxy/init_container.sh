#!/bin/bash
echo "Setup openrc ..." && openrc && touch /run/openrc/softlevel
[ -e "/home/site/nginx.conf" ] && cp "/home/site/nginx.conf" "/etc/nginx/nginx.conf"
test ! -d "$SUPERVISOR_LOG_DIR" && echo "INFO: $SUPERVISOR_LOG_DIR not found. creating ..." && mkdir -p "$SUPERVISOR_LOG_DIR"

cd /usr/bin/
supervisord -c /etc/supervisor/conf.d/supervisord.conf