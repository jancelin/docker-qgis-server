#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM debian:jessie-slim
MAINTAINER julien ANCELIN docker-qgis-server
RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl
# add qgis to sources.list
RUN echo "deb http://qgis.org/debian-ltr jessie main" >> /etc/apt/sources.list
RUN gpg --keyserver keyserver.ubuntu.com --recv 3FF5FFCAD71472C4
RUN gpg --export --armor 3FF5FFCAD71472C4 | apt-key add -
RUN apt-get -y update
#--------------------------------------------------------------------------------------------
# Install stuff
RUN apt-get install -y qgis-server python-qgis apache2 libapache2-mod-fcgid unzip --force-yes
#Install wfsOutputExtension plugin
RUN sudo mkdir -p /opt/qgis-server/plugins
ADD https://github.com/3liz/qgis-wfsOutputExtension/archive/master.zip /opt/qgis-server/plugins
RUN unzip /opt/qgis-server/plugins/master.zip 
RUN mv /opt/qgis-server/plugins/qgis-wfsOutputExtension-master /opt/qgis-server/plugins/wfsOutputExtension
#virtual host
ADD 001-qgis-server.conf /etc/apache2/sites-available/001-qgis-server.conf
#Setting up Apache
RUN export LC_ALL="C" && a2enmod fcgid && a2enconf serve-cgi-bin
RUN a2dissite 000-default
RUN a2ensite 001-qgis-server
EXPOSE 80
ADD start.sh /start.sh
RUN chmod +x /start.sh
CMD /start.sh
