FROM centos:centos6
#FROM store/appdynamics/java:4.3.7.1_tomcat9-jre8

RUN yum -y install unzip

# Actual file paths passed via docker-compose.yml
#COPIED OUT
ARG APPD_AGENT_ZIP
ARG APPD_AGENT_SHA256

# Canonical filenames used in startup script
ENV AGENT_ZIP AppServerAgent.zip
ENV AGENT_SHA256 AppServerAgent.checksum

ENV APPD_TMP /tmp

COPY ${APPD_AGENT_ZIP} /${AGENT_ZIP}
RUN echo "${APPD_AGENT_SHA256} *${AGENT_ZIP}" >> /$AGENT_SHA256

#COPIED OUT
RUN sha256sum -c ${AGENT_SHA256}

COPY appdynamics.sh /appdynamics.sh

COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

CMD "/startup.sh"
