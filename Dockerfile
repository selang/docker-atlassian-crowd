FROM		hauptmedia/java:oracle-java8
MAINTAINER	Julian Haupt <julian.haupt@hauptmedia.de>

ENV		CROWD_VERSION 2.8.3
ENV		MYSQL_CONNECTOR_J_VERSION 5.1.34

ENV		CROWD_HOME     		/var/atlassian/application-data/crowd
ENV		CROWD_INSTALL_DIR	/opt/atlassian/crowd

ENV             DEBIAN_FRONTEND noninteractive

# install needed debian packages & clean up
RUN             apt-get update && \
                apt-get install -y --no-install-recommends curl tar xmlstarlet ca-certificates git && \
                apt-get clean autoclean && \
                apt-get autoremove --yes && \
                rm -rf /var/lib/{apt,dpkg,cache,log}/

# download and extract crowd 
RUN             mkdir -p ${CROWD_INSTALL_DIR} && \
                curl -L --silent https://www.atlassian.com/software/crowd/downloads/binary/atlassian-crowd-${CROWD_VERSION}.tar.gz | tar -xz --strip=1 -C ${CROWD_INSTALL_DIR}

# integrate mysql connector j library
RUN             curl -L --silent http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_CONNECTOR_J_VERSION}.tar.gz | tar -xz --strip=1 -C /tmp && \
                cp /tmp/mysql-connector-java-${MYSQL_CONNECTOR_J_VERSION}-bin.jar ${CROWD_INSTALL_DIR}/lib && \
                rm -rf /tmp/*

# add docker-entrypoint.sh script
#COPY            docker-entrypoint.sh ${STASH_INSTALL_DIR}/bin/

# HTTP Port
EXPOSE		8095	

VOLUME		["${CROWD_INSTALL_DIR}"]

WORKDIR		${CROWD_INSTALL_DIR}

#ENTRYPOINT	["bin/docker-entrypoint.sh"]
#CMD		["bin/start-bitbucket.sh", "-fg"]
