FROM ubuntu:14.04

# Install required packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y unzip && \
    apt-get clean

# Actual file paths passed via docker-compose.yml
ARG APPD_MA_ZIP
ARG APPD_MA_SHA256

# Canonical filenames used in startup script
ENV MA_ZIP MachineAgentBundle.zip
ENV MA_SHA256 MachineAgentBundle.checksum

COPY ${APPD_MA_ZIP} /${MA_ZIP}
RUN echo "${APPD_MA_SHA256} *${MA_ZIP}" >> /$MA_SHA256
RUN sha256sum -c ${MA_SHA256}

# Install AppDynamics Machine Agent
ENV MACHINE_AGENT_HOME /opt/appdynamics/machine-agent/
RUN cp ${MA_ZIP} /tmp/ && \ 
    mkdir -p ${MACHINE_AGENT_HOME} && \
    unzip -oq /tmp/${MA_ZIP} -d ${MACHINE_AGENT_HOME} && \
    rm /tmp/${MA_ZIP}

# Include start script to configure and start MA at runtime
ADD start-appdynamics ${MACHINE_AGENT_HOME}
RUN chmod 744 ${MACHINE_AGENT_HOME}/start-appdynamics

# Configure and Run AppDynamics Machine Agent
CMD "${MACHINE_AGENT_HOME}/start-appdynamics"

# Analytics Agent listener
EXPOSE 9090
