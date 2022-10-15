FROM centos:centos7

RUN yum update -y && yum install -y \
  net-tools \
  iproute \
  tcpdump \
  curl  \
  unzip   \
  sysvinit-tools \
  openssh-clients

WORKDIR /netviz-agent

ARG NETVIZ_ZIP_PKG

# copy NetViz agent contents
ADD ${NETVIZ_ZIP_PKG} .

# run the agent install script
RUN unzip *.zip && ./install.sh \
    && sed -i -e "s|enable_netlib = 1|enable_netlib = 0|g" ./conf/agent_config.lua \
    && sed -i -e "s|WEBSERVICE_IP=.*|WEBSERVICE_IP=\"0.0.0.0\"|g" ./conf/agent_config.lua \
    && sed -i -e "s|threads =.*|threads = 50,|g" ./conf/agent_config.lua 
ADD startup.sh /
RUN chmod 744 /startup.sh
# default command to run for the agent
# CMD  ./bin/appd-netagent -c ./conf -l ./logs -r ./run
CMD "/startup.sh"