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
RUN apt-get install -y qgis-server nginx supervisor php5-fpm php5-curl php5-cli php5-sqlite \
    php5-pgsql php5-gd php5-ldap --force-yes

ADD supervisor/supervisord.conf /etc/supervisor/supervisord.conf
ADD supervisor/php.conf supervisor/nginx.conf supervisor/qgis.conf /etc/supervisor/conf.d/ 

ADD nginx/*  /etc/nginx/sites-enabled/

# Tweak php-fpm configuration
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf

# Expose ports
EXPOSE 80 8200

# Run supervisor
CMD supervisord
