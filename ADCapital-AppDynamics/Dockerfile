FROM centos:centos7

RUN yum -y install unzip sysvinit-tools lsof java-1.8.0-openjdk && yum clean all

# Actual file paths passed via docker-compose.yml
ARG APPD_UA_ZIP
ARG APPD_UA_SHA256

# Enable debug for UA
ARG APPD_UA_DEBUG

# Canonical filenames used in startup script
ENV UA_ZIP UniversalAgent.zip
ENV UA_SHA256 UniversalAgent.checksum

ENV UA_HOME /opt/appdynamics/universal-agent
ENV UA_INSTALL /ua

# Validate checksum for Universal Agent zip distribution
COPY ${APPD_UA_ZIP} /${UA_ZIP}
RUN echo "${APPD_UA_SHA256} *${UA_ZIP}" >> /$UA_SHA256
RUN sha256sum -c ${UA_SHA256}

# Install Universal Agent (Controller properties will be set at runtime)
RUN unzip -q /${UA_ZIP} -d ${UA_INSTALL}; rm /${UA_ZIP}
RUN chmod +x $(find ${UA_INSTALL} -maxdepth 1 -type d -name "ua?.?.?.?")/bin/install.sh
RUN $(find ${UA_INSTALL} -maxdepth 1 -type d -name "ua?.?.?.?")/bin/install.sh  \
 -controller_host "HOST" -controller_port "1234" \
 -account_name "ACCOUNT_NAME" -account_access_key "ACCESS_KEY" -global_account_name "GLOBAL_ACCOUNT_NAME" \
 -no_service
RUN ${UA_HOME}/ua --set-mode local
COPY local.json ${UA_HOME}/rulebook

COPY appdynamics.sh /appdynamics.sh

COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

CMD "/startup.sh"

# Analytics Agent listener
EXPOSE 9090
