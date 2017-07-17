FROM centos:centos6

RUN yum -y install unzip
RUN yum -y install tar
RUN yum -y install wget
RUN yum -y install ntp

ENV JAVA_HOME /usr/java/default
ENV PATH $PATH:$JAVA_HOME/bin

ENV DOCKERIZE_VERSION v0.5.0
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# Actual file paths passed via docker-compose.yml
ARG ORACLE_JDK_RPM
ARG ORACLE_JDK_SHA256

# Canonical filenames used in startup script
ENV JDK_RPM jdk-linux-x64.rpm
ENV JDK_SHA256 jdk-linux-x64.checksum

COPY ${ORACLE_JDK_RPM} /${JDK_RPM}
RUN echo "${ORACLE_JDK_SHA256} *${JDK_RPM}" >> /$JDK_SHA256
RUN sha256sum -c ${JDK_SHA256}

# Install Oracle JDK
RUN rpm -Uvh /${JDK_RPM} && rm ${JDK_RPM}

# Add appdynamics:appdynamics user
RUN groupadd -r -g 2002 appdynamics
RUN useradd --create-home --gid appdynamics -u 2001 appdynamics
RUN echo 'appdynamics:appdynamics' | chpasswd
