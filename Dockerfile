#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM resin/rpi-raspbian:jessie
MAINTAINER julien ANCELIN rpi_docker-qgis-server
RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl
# add sid to sources.list
MAINTAINER 1
#RUN echo "deb    http://http.debian.net/debian sid main " >> /etc/apt/sources.list
#RUN gpg --keyserver pgpkeys.mit.edu --recv-key 7638D0442B90D010
#RUN gpg -a --export 7638D0442B90D010 | sudo apt-key add -
#RUN gpg --keyserver pgpkeys.mit.edu --recv-key 8B48AD6246925553
#RUN gpg -a --export 8B48AD6246925553 | sudo apt-key add -
RUN apt-get  -y update
#--------------------------------------------------------------------------------------------
# Install stuff
#RUN apt-get clean -y
RUN  apt-get -f install -y apache2 libapache2-mod-fcgid --force-yes --fix-missing
#--force-yes --fix-missing
RUN echo "deb http://qgis.org/debian-ltr jessie main " >> /etc/apt/sources.list
RUN apt-get -y install wget
RUN wget -O - http://qgis.org/downloads/qgis-2016.gpg.key | gpg --import
RUN gpg --fingerprint 073D307A618E5811
RUN gpg -a --export --armor 073D307A618E5811 | sudo apt-key add -
RUN apt-get -y update

RUN  apt-get -f install -y qgis-server --force-yes --fix-missing
#--force-yes --fix-missing
ADD 001-qgis-server.conf /etc/apache2/sites-available/001-qgis-server.conf
#Setting up Apache
RUN export LC_ALL="C" && a2enmod fcgid && a2enconf serve-cgi-bin
RUN a2dissite 000-default
RUN a2ensite 001-qgis-server
EXPOSE 80
ADD start.sh /start.sh
RUN chmod +x /start.sh
CMD /start.sh
