#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM camptocamp/qgis-server:3
#--------------------------------------------------------------------------------------------
# Install stuff
RUN apt-get update && apt-get install -y apache2 libapache2-mod-fcgid --force-yes
ADD 001-qgis-server.conf /etc/apache2/sites-available/001-qgis-server.conf
#Setting up Apache
RUN export LC_ALL="C" && a2enmod fcgid && a2enconf serve-cgi-bin
RUN a2dissite 000-default
RUN a2ensite 001-qgis-server
EXPOSE 8900
ADD start.sh /start.sh
RUN chmod +x /start.sh
CMD /start.sh
