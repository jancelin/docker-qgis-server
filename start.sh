#!/bin/sh
set -e

# Apache gets grumpy about PID files pre-existing
rm -f /usr/local/apache2/logs/httpd.pid

service apache2 restart

# avoid containers closing and keep it open
tail -f /dev/null
