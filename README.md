# docker-qgis-server


Build image
-----------

* To build qgis-server with Docker on a PC,server

```
docker build -t "qgiserver" https://github.com/jancelin/docker-qgis-server.git#2.14LTR-wfsOutputExtension:/ -f Dockerfile
```

* To build qgis-server with Docker on a Raspberry Pi

```
docker build -t "qgiserver" https://github.com/jancelin/docker-qgis-server.git#2.14LTR-wfsOutputExtension:/ -f Dockerfile.raspberry
```

Or Pull from DockerHub
----------------------

* PC
```
docker pull jancelin/qgis-server:2.14LTR-wfsOutputExtension
```

* Raspberry

```
docker pull jancelin/geopoppy:qgis-server2.14LTR-0.2
```



Play qgis server with docker-compose
------------------------------------------
* Create a docker-compose.yml

```
version: '2'
services:
  qgiserver:
    image: jancelin/qgis-server:2.14LTR-wfsOutputExtension
    restart: always
    volumes:
      - /home/lizmap/project:/home
    ports:
      - 80:80
```


* Create a docker-compose.yml with qgis server and lizmap for PC or Raspberry Pi

https://github.com/jancelin/docker-lizmap/blob/3.1.1-0.1/docker-compose.yml


----------------------------------------

Load Balancing demo
-------------------

Run 1 or more qgis server with load balancing

* Update your docker-compose.yml

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

CORS enabled
------------
Cors are enabled by default with following headers
- Access-Control-Allow-Origin "*"
- Access-Control-Allow-Methods "POST, GET, OPTIONS, DELETE, PUT"
- Access-Control-Allow-Headers "authorization,cache-control,expires,pragma"