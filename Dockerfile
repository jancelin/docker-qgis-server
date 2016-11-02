#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM debian:jessie
MAINTAINER julien ANCELIN docker-qgis-server
RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl
# add qgis to sources.list
RUN echo "deb http://qgis.org/debian jessie main" >> /etc/apt/sources.list
RUN gpg --keyserver keyserver.ubuntu.com --recv 3FF5FFCAD71472C4
RUN gpg --export --armor 3FF5FFCAD71472C4 | apt-key add -
RUN apt-get -y update
#--------------------------------------------------------------------------------------------
# Install stuff
RUN apt-get install -y qgis-server python-qgis --force-yes
RUN apt-get install -y apache2 libapache2-mod-fcgid --force-yes
RUN a2enmod rewrite
RUN echo "Listen 80" >> /etc/apache2/conf-available/qgis-server-port.conf
RUN a2enconf qgis-server-port
ADD 001-qgis-server.conf /etc/apache2/sites-available/001-qgis-server.conf
RUN a2ensite 001-qgis-server
EXPOSE 80
CMD apachectl -D FOREGROUND

