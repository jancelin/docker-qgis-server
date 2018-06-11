#!/bin/sh
set -e
# enable xvfb
systemctl enable xvfb.service &&
systemctl start xvfb.service
# Apache gets grumpy about PID files pre-existing
rm -f /usr/local/apache2/logs/httpd.pid

service apache2 restart

# avoid containers closing and keep it open
tail -f /dev/null
