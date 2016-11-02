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
RUN apt-get install -y qgis-server libapache2-mod-fcgid vim --force-yes 

RUN a2enmod fcgid

# Remove the default mod_fcgid configuration file
#RUN rm -v /etc/apache2/mods-enabled/fcgid.conf
# Copy a configuration file from the current directory
#ADD apache/fcgid.conf /etc/apache2/mods-enabled/fcgid.conf
# Open port 80 & mount /home 
EXPOSE 80

#add start.sh on first install, generate config file: ~/lizmap/var
ADD start.sh /apache/start.sh
RUN chmod 0755 /apache/start.sh
# Now launch apache in the foreground
CMD /apache/start.sh
