#!/bin/sh
set -e

# Apache gets grumpy about PID files pre-existing
rm -f /usr/local/apache2/logs/httpd.pid

service apache2 restart

# avoid containers closing and keep it open
tail -f /dev/null

# for print map
Xvfb :99 -screen 0 1024x768x24 -ac +extension GLX +render -noreset &
