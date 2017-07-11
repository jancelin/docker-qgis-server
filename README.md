# docker-qgis-server


to build qgis-server with Docker on a Raspberry Pi

```
docker build  -t "jancelin/qgis-server:2.14LTR-wfsOutputExtension" https://github.com/jancelin/docker-qgis-server.git#2.14LTR-wfsOutputExtension:/
```

docker-compose.yml

```
version: '2'
services:
#---WEBSIG-------------------------------------
  lizmap:
    image: jancelin/geopoppy:lizmap-3.1.1
    restart: always
    ports:
     - 80:80
     - 443:443
    volumes:
     - /home/GeoPoppy/lizmap/project:/home
     - /home/GeoPoppy/lizmap/project/var:/var/www/websig/lizmap/var
     - /home/GeoPoppy/lizmap/project/tmp:/tmp
    links:
     - qgiserver:qgiserver
##Change l'URL WMS in Lizmap back-office: http://qgiserver/cgi-bin/qgis_mapserv.fcgi

  qgiserver:
    image: jancelin/qgis-server:2.14LTR-2.14LTR-wfsOutputExtension
    restart: always
    volumes:
      - /home/GeoPoppy/lizmap/project:/home
    expose:
      - 80

```

----------------------------------------
Load Balancing demo
-------------------

run 1 or more qgis server with load balancing

* update your docker-compose.yml

```
version: '2'
services:
  lb:
    image: dockercloud/haproxy
    links:
      - qgiserver
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - MONITOR_PORT
    ports:
      - 8900:80
      
  qgiserver:
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



