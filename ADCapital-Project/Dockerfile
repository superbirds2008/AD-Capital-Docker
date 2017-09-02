FROM appdynamics/adcapital-java:latest

RUN yum install -y git java-1.8.0-openjdk-devel && yum clean all

# Install Gradle
RUN curl -O http://downloads.gradle.org/distributions/gradle-2.1-bin.zip && \
    unzip gradle-2.1-bin.zip -d /opt/ && \
    rm gradle-2.1-bin.zip
ENV GRADLE_HOME /opt/gradle-2.1
ENV PATH $PATH:$GRADLE_HOME/bin

# Clone source repo from GitHub
RUN git clone https://github.com/Appdynamics/AD-Capital.git

# Gradle build
RUN cd /AD-Capital; gradle build uberjar

# Shared directory mounted as docker volume
ENV PROJECT /src

ADD startup.sh /
RUN chmod 744 /startup.sh

CMD "/startup.sh"
