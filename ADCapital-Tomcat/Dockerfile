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
ENV UA_INSTALL /ua
ENV UA_HOME /opt/appdynamics/universal-agent

# Install rsyslog to tail log file
RUN yum install -y rsyslog

# Install sudo for Universal Agent
RUN yum install -y sudo

# Install Tomcat
RUN curl -O -k https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz \
    && curl -O -k https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz.md5 \
    && md5sum apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz.md5 \
    && tar zxf apache-tomcat-*.tar.gz \
    && rm apache-tomcat-*.tar.gz* \
    && mv apache-tomcat-${TOMCAT_MINOR_VERSION} ${CATALINA_HOME}
RUN cd ${CATALINA_HOME}/bin;chmod +x *.sh
RUN chown -R appdynamics:appdynamics ${CATALINA_HOME}

# Universal Agent Install
ADD UniversalAgent.zip /
RUN unzip -q /UniversalAgent.zip -d ${UA_INSTALL};rm /UniversalAgent.zip

# Add Log Analytics job files
#ADD portal-log4j.job ${MACHINE_AGENT_HOME}/
#ADD processor-log4j.job ${MACHINE_AGENT_HOME}/
#ADD rest-log4j.job ${MACHINE_AGENT_HOME}/

RUN export TERM=${TERM:-xterm}

# Copy AD-Capital project from build dir
ADD AD-Capital /AD-Capital

# Gradle build
RUN cd /AD-Capital;gradle build;

ADD env.sh /
ADD startup.sh /
RUN chmod 744 /startup.sh
ADD restart.sh /usr/bin/restart
RUN chmod 744 /usr/bin/restart
ADD ua-debug.sh /usr/bin/ua-debug
RUN chmod 744 /usr/bin/ua-debug
ADD start-analytics.sh /usr/bin/start-analytics
RUN chmod 744 /usr/bin/start-analytics

# Note: This command should not return or the container will exit
CMD "/startup.sh"

EXPOSE 80
EXPOSE 8080
EXPOSE 8009
