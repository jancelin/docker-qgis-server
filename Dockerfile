#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM resin/rpi-raspbian:jessie
MAINTAINER julien ANCELIN rpi_docker-qgis-server
RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl
# add sid to sources.list
MAINTAINER 1
RUN echo "deb    http://http.debian.net/debian sid main " >> /etc/apt/sources.list
RUN gpg --keyserver pgpkeys.mit.edu --recv-key 7638D0442B90D010
RUN gpg -a --export 7638D0442B90D010 | sudo apt-key add -
RUN gpg --keyserver pgpkeys.mit.edu --recv-key 8B48AD6246925553
RUN gpg -a --export 8B48AD6246925553 | sudo apt-key add -
RUN apt-get  -y update
#--------------------------------------------------------------------------------------------
# Install stuff
#RUN apt-get clean -y
RUN apt-get -t sid -f install -y apt-utils --force-yes --fix-missing
RUN apt-get -t sid install -f 
RUN apt-get -t sid -f install -y apache2 libapache2-mod-fcgid --force-yes --fix-missing
RUN apt-get -t sid -f install -y qgis-server  --force-yes --fix-missing
ADD 001-qgis-server.conf /etc/apache2/sites-available/001-qgis-server.conf
#Setting up Apache
RUN export LC_ALL="C" && a2enmod fcgid && a2enconf serve-cgi-bin
RUN a2dissite 000-default
RUN a2ensite 001-qgis-server
EXPOSE 80
ADD start.sh /start.sh
RUN chmod +x /start.sh
CMD /start.sh
