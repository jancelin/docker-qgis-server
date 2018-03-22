#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM debian:stretch-slim
MAINTAINER julien ANCELIN docker-qgis-server
RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl
RUN apt-get -y update
RUN apt-get install -y gnupg apt-transport-https ca-certificates
# add qgis to sources.list
RUN echo "deb http://qgis.org/debian-ltr strech main" >> /etc/apt/sources.list
RUN gpg --keyserver keyserver.ubuntu.com --recv 073D307A618E5811
RUN gpg --export --armor 073D307A618E5811 | apt-key add -
RUN apt --fix-broken install 
RUN apt-get -y update
#--------------------------------------------------------------------------------------------
# Install stuff
RUN apt-get install -y qgis-server python-qgis apache2 libapache2-mod-fcgid unzip --force-yes
#Install wfsOutputExtension plugin
RUN mkdir -p /opt/qgis-server && mkdir -p /opt/qgis-server/plugins
ADD https://github.com/3liz/qgis-wfsOutputExtension/archive/master.zip /opt/qgis-server/plugins
RUN unzip /opt/qgis-server/plugins/master.zip -d /opt/qgis-server/plugins/
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
