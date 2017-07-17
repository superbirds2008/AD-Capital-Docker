FROM centos:centos6

RUN yum -y install unzip

ARG APPD_AGENT_ZIP
ARG APPD_AGENT_SHA256

ENV APPD_TMP /tmp
ENV AGENT_ZIP AppServerAgent.zip
ENV AGENT_SHA256 AppServerAgent.checksum

COPY ${APPD_AGENT_ZIP} /${AGENT_ZIP}
RUN echo "${APPD_AGENT_SHA256} *${AGENT_ZIP}" >> /$AGENT_SHA256
RUN sha256sum -c ${AGENT_SHA256}

COPY appdynamics.sh /appdynamics.sh

COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

CMD "/startup.sh"
