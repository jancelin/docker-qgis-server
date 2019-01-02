# docker-qgis-server

run 1 or more qgis server with load balancing

* update your docker-compose.yml

```
version: '2'
services:
  lb:
    image: dockercloud/haproxy
    links:
      - qgisserver
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - MONITOR_PORT
    ports:
      - 8900:80
      
  qgisserver:
    image: jancelin/qgis-server:2.14LTR
    restart: always
    volumes:
      - "/home/qgis_files:/home"
    expose:
      - 80
```

* up

```
docker-compose up -d lb
```

* scale (ex:15 qgis-sever)

```
docker-compose scale qgisserver=15
```

* Test if qgis-server working

> http://localhost:8900/cgi-bin/qgis_mapserv.fcgi?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetCapabilities

* Enjoy

* show statistics:

http://internal_lb_ip:1936

>ex: http://172.18.0.2:1936

> login: stats

> password: stats



