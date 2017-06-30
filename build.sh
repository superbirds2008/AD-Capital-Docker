# This script is provided for illustration purposes only.
#
# To build the ADCapital demo application, you will need to download the following components:
# 1. An appropriate version of the Oracle Java 7 JDK
#    (http://www.oracle.com/technetwork/java/javase/downloads/index.html)

#! /bin/bash

# Usage information
if [[ $1 == *--help* ]]; then
  echo "Specify agent locations: build.sh
          -u <Path to Universal Agent>
          -m <Path to Machine Agent>
          [-j <Path to Oracle JDK7>]"
  echo "Prompt for agent locations: build.sh"
  exit 0
fi

cleanUp() {
  # Remove AppDyanmics installers and Oracle JDK
  (cd ADCapital-Tomcat && rm -f UniversalAgent.zip)
  (cd ADCapital-Java && rm -f jdk-linux-x64.rpm)
  (cd ADCapital-Monitor && rm -f machine-agent.zip)

  # Remove dangling images left-over from build
  if [[ `docker images -q --filter "dangling=true"` ]]; then
    echo
    echo "Deleting intermediate containers..."
    docker images -q --filter "dangling=true" | xargs docker rmi;
  fi
}
trap cleanUp EXIT

promptForAgents() {
  read -e -p "Enter path to Universal Agent: " UNIVERSAL_AGENT
  read -e -p "Enter path to Machine Agent (zip): " MACHINE_AGENT
  read -e -p "Enter path to Oracle JDK7: " ORACLE_JDK7
}

buildContainers() {
  echo; echo "Building ADCapital-Java..."
  cp ${ORACLE_JDK7} ADCapital-Java/jdk-linux-x64.rpm
  (cd ADCapital-Java; docker build -t appdynamics/adcapital-java .) || exit $?

  echo; echo "Building ADCapital-Tomcat..."
  (cd ADCapital-Tomcat && docker build -t appdynamics/adcapital-tomcat .) || exit $?

  echo; echo "Building ADCapital-Load..."
  (cd ADCapital-Load && docker build -t appdynamics/adcapital-load .) || exit $?

  echo; echo "Building ADCapital-Monitor..."
  cp ${MACHINE_AGENT} ADCapital-Monitor/machine-agent.zip
  (cd ADCapital-Monitor && docker build -t appdynamics/adcapital-monitor .) || exit $?

  echo; echo "Building ADCapital-Project..."
  (cd ADCapital-Project && docker build -t appdynamics/adcapital-project .) || exit $?
}


if  [ $# -eq 0 ]; then
  # Default: Prompt user for locations of AppDynamics Agents
  promptForAgents

else
  # Allow user to specify locations of AppDynamics Agents via commandline
  while getopts "j:u:m:" opt; do
    case $opt in
      u)
        UNIVERSAL_AGENT=$OPTARG
        if [ ! -e ${UNIVERSAL_AGENT} ]; then
          echo "Not found: ${UNIVERSAL_AGENT}"; exit
        fi
        ;;
      m)
        MACHINE_AGENT=$OPTARG 
	if [ ! -e ${MACHINE_AGENT} ]; then
          echo "Not found: ${MACHINE_AGENT}"; exit         
        fi
        ;;
      j)
        ORACLE_JDK7=$OPTARG
        if [ ! -e ${ORACLE_JDK7} ]; then
          echo "Not found: ${ORACLE_JDK7}"; exit
        fi
        ;; 
      \?)
        echo "Invalid option: -$OPTARG"
        ;;
    esac
  done

fi

buildContainers
