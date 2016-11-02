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
RUN a2enmod rewrite; a2enconf qgis-server-port;


ADD start.sh /start.sh
RUN chmod 0755 /start.sh
# Now launch apache in the foreground
CMD /start.sh
