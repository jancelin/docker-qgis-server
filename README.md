# docker-qgis-server

{{< importPartial "https://raw.githubusercontent.com/jancelin/geo-poppy/master/collec/docker-compose.yml" >}}

run 1 or more qgis server with load balancing

* update your docker-compose.yml

```
version: '2'
services:
  haproxy:
    image: hypriot/rpi-haproxy
    restart: always
    volumes:
     - /home/pirate/haproxy:/haproxy-override
    links:
     - qgiserver
     - qgiserver1
    ports:
     - "8900:80" 
     - "70:70"
     
  qgiserver:
    image: jancelin/geopoppy:qgis-server2.14LTR
    restart: always
    volumes:
      - "/home/GeoPoppy/lizmap/project:/home"
    expose:
      - 80 
      
  qgiserver1:
    image: jancelin/geopoppy:qgis-server2.14LTR
    restart: always
    volumes:
      - "/home/GeoPoppy/lizmap/project:/home"
    expose:
      - 80
```

* HAProxy needs a configuration file that is mapped into the container. Create a file haproxy/haproxy.cfg with the following content.

```
global
  log 127.0.0.1 local0
  log 127.0.0.1 local1 notice

defaults
  log global
  mode http
  option httplog
  option dontlognull
  timeout connect 5000
  timeout client 10000
  timeout server 10000

listen stats :70
  stats enable
  stats uri /

frontend balancer
  bind 0.0.0.0:80
  mode http
  default_backend aj_backends

backend aj_backends
  mode http
  option forwardfor
  # http-request set-header X-Forwarded-Port %[dst_port]
  balance roundrobin
  server qgiserver qgiserver:80 check
  server qgiserver1 qgiserver1:80 check
  # option httpchk OPTIONS * HTTP/1.1\r\nHost:\ localhost
  option httpchk GET /
  http-check expect status 200
```

* up

```
docker-compose up -d 
```

* Test if qgis-server working

> http://172.24.1.1:8900/cgi-bin/qgis_mapserv.fcgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities

* stats

http://172.24.1.1:70

* Enjoy




