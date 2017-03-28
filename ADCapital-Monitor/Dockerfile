FROM appdynamics/adcapital-java:latest

# Install rsyslog to tail log file
RUN yum install -y rsyslog

# Zip Machine Agent Install
ENV MACHINE_AGENT_HOME /machine-agent
ADD MachineAgent.zip /
RUN unzip -oq /MachineAgent.zip -d ${MACHINE_AGENT_HOME}
RUN rm MachineAgent.zip

RUN export TERM=${TERM:-dumb}

ADD env.sh /
ADD startup.sh /
RUN chmod 744 /startup.sh

# Note: This command should not return or the container will exit
CMD "/startup.sh"

EXPOSE 80
EXPOSE 8080
EXPOSE 8009
