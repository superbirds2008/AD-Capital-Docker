FROM openjdk:8

RUN apt-get install -y git
ENV http_prxoy=http://proxy-wsa.esl.cisco.com:80
ENV https_proxy=http://proxy-wsa.esl.cisco.com:80
# Install Gradle (unzip this into the shared volume (into appdynamics))
RUN wget https://downloads.gradle.org/distributions/gradle-2.1-bin.zip
RUN unzip gradle-2.1-bin.zip -d /opt
RUN rm gradle-2.1-bin.zip

ENV GRADLE_HOME /opt/gradle-2.1
ENV PATH $PATH:$GRADLE_HOME/bin

# Clone source repo from GitHub
RUN git config --global http.proxy http://proxy-wsa.esl.cisco.com:80
RUN git clone -b logging --single-branch https://github.com/Appdynamics/AD-Capital.git

# Gradle build
RUN cd /AD-Capital; gradle -Dhttp.proxyHost=proxy-wsa.esl.cisco.com -Dhttp.proxyPort=80 build uberjar

# Shared directory mounted as docker volume
ENV PROJECT /project

ADD startup.sh /
RUN chmod 744 /startup.sh

CMD "/startup.sh"
