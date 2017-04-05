FROM ubuntu:14.04
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y  software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get clean
RUN apt-get install -y vim
RUN apt-get install -y curl
RUN apt-get install -y zip
RUN apt-get install -y rsyslog

# Zip Machine Agent Install
ENV MACHINE_AGENT_HOME /machine-agent
ADD MachineAgent.zip /
RUN unzip -oq /MachineAgent.zip -d ${MACHINE_AGENT_HOME}
RUN rm MachineAgent.zip

# Workaround for bug https://singularity.jira.com/browse/PEM-99
RUN (cd ${MACHINE_AGENT_HOME}/monitors; mv analytics-agent-bundle-32bit-windows analytics-agent; rm -rf analytics-agent/jre)

RUN export TERM=${TERM:-xterm}

ADD env.sh /
ADD startup.sh /
RUN chmod 744 /startup.sh

# Note: This command should not return or the container will exit
CMD "/startup.sh"

# Analytics Agent listener
EXPOSE 9090
