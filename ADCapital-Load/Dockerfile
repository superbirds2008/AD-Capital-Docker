FROM appdynamics/adcapital-java:latest

# Gradle
RUN curl -O http://downloads.gradle.org/distributions/gradle-2.1-bin.zip
RUN unzip gradle-2.1-bin.zip -d /opt/
RUN rm gradle-2.1-bin.zip
ENV GRADLE_HOME /opt/gradle-2.1
ENV PATH $PATH:$GRADLE_HOME/bin

# Clone source repo from GitHub
RUN yum install -y git
RUN git clone https://github.com/Appdynamics/AD-Capital-Load.git

ENV LOAD_GEN_PROJECT /AD-Capital-Load
RUN cd ${LOAD_GEN_PROJECT}; gradle distZip
RUN unzip ${LOAD_GEN_PROJECT}/build/distributions/load-generator.zip -d /
RUN chmod +x ${LOAD_GEN_PROJECT}/bin/*

ADD startup.sh /
RUN chmod +x /startup.sh

CMD ["/bin/bash", "-c", "/startup.sh"]
