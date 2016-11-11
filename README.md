# docker-qgis-server

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

* up

```
docker-compose up -d lb
```

* scale (ex:15 qgis-sever)

```
docker-compose scale qgiserver=15
```

* Test if qgis-server working

> http://localhost:8900/cgi-bin/qgis_mapserv.fcgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities

* Enjoy

* show statistics:

http://internal_lb_ip:1936

>ex: http://172.18.0.2:1936

> login: stats

> password: stats



