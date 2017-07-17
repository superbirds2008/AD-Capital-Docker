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

# Install Oracle JDK
ADD jdk-linux-x64.rpm /
RUN rpm -Uvh /jdk-linux-x64.rpm
RUN rm jdk-linux-x64.rpm

# Add appdynamics:appdynamics user
RUN groupadd -r -g 2002 appdynamics
RUN useradd --create-home --gid appdynamics -u 2001 appdynamics
RUN echo 'appdynamics:appdynamics' | chpasswd
