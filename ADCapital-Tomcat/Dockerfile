FROM appdynamics/adcapital-java:latest

# Install Gradle
RUN curl -O http://downloads.gradle.org/distributions/gradle-2.1-bin.zip
RUN unzip gradle-2.1-bin.zip -d /opt/
RUN rm gradle-2.1-bin.zip
ENV GRADLE_HOME /opt/gradle-2.1
ENV PATH $PATH:$GRADLE_HOME/bin

# Environment vars: Tomcat
ENV TOMCAT_MAJOR_VERSION 8
ENV TOMCAT_MINOR_VERSION 8.0.14
ENV CATALINA_HOME /tomcat

# Install rsyslog to tail log file
RUN yum install -y rsyslog

# Install Tomcat
RUN curl -O -k https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz \
    && curl -O -k https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz.md5 \
    && md5sum apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz.md5 \
    && tar zxf apache-tomcat-*.tar.gz \
    && rm apache-tomcat-*.tar.gz* \
    && mv apache-tomcat-${TOMCAT_MINOR_VERSION} ${CATALINA_HOME}
RUN cd ${CATALINA_HOME}/bin;chmod +x *.sh
RUN chown -R appdynamics:appdynamics ${CATALINA_HOME}

# Shared directory mounted as docker volume
ENV PROJECT /src

ADD startup.sh /
RUN chmod 744 /startup.sh

# Note: This command should not return or the container will exit
CMD "/startup.sh"

EXPOSE 80
EXPOSE 8080
EXPOSE 8009
