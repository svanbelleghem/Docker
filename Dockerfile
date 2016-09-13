############################################################
# Dockerfile to build MariaDB container images
# Based on Ubuntu
############################################################

# Set the base image to Ubuntu
FROM ubuntu

# File Author / Maintainer
MAINTAINER Sander van Belleghem

# Update the repository sources list
RUN apt-get update

################## BEGIN INSTALLATION ######################
# Install MariaDB Following the Instructions at MongoDB Docs
# Ref: https://hub.docker.com/_/mariadb/

# Add the package verification key
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0xcbcb082a1bb943db

# Add MariaDB to the repository sources list
RUN echo "deb http://mariadb.mirror.iweb.com/repo/10.0/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/mariadb.list

# Update the repository sources list once more
RUN apt-get update

# Don't know what happens here, description missing from this point
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y mariadb-server

# Description
RUN rm -rf /var/lib/apt/lists/*

# Description
RUN sed -i 's/^\(bind-address\s.*\)/# \1/' /etc/mysql/my.cnf

# Description
RUN echo "mysqld_safe &" > /tmp/config

# Description
RUN echo "mysqladmin --silent --wait=30 ping || exit 1" >> /tmp/config

# Description
RUN echo "mysql -e 'GRANT ALL PRIVILEGES ON *.* TO \"root\"@\"%\" WITH GRANT OPTION;'" >> /tmp/config

# Description
RUN bash /tmp/config

# Description
RUN rm -f /tmp/config

# Define mountable directories
VOLUME ["/etc/mysql", "/var/lib/mysql"]

# Define working directory
WORKDIR /data

# Define default command
CMD ["mysqld_safe"]

# Expose ports
EXPOSE 3306

##################### INSTALLATION END #####################
