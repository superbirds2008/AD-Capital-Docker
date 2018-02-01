#!/bin/bash

# Add AppDynamics Agent properties if shared volume is mounted
# APPD_JAVAAGENT and APPD_PROPERTIES environment variables will be set

if [ -e ${APPD_DIR}/appdynamics.sh ]; then
  . ${APPD_DIR}/appdynamics.sh
fi

# Uncomment and expose port 8888 to enable JMX remote monitoring
#export JMX_OPTS="-Dcom.sun.management.jmxremote.port=8888  -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"

# Specialize container behavior based on ROLE env var
# Uses https://github.com/jwilder/dockerize to check service dependencies
# Binaries and Gradle scripts are sourced from ${PROJECT} docker shared volume
case ${ROLE} in
rest)
  dockerize -wait tcp://adcapitaldb:3306 \
            -wait-retry-interval ${RETRY} -timeout ${TIMEOUT} || exit $?

  cd ${PROJECT}/AD-Capital; gradle createDB

  cp  ${PROJECT}/AD-Capital/Rest/build/libs/Rest.war ${CATALINA_HOME}/webapps;
  cd ${CATALINA_HOME}/bin;


  /docker-java-home/jre/bin/java ${APPD_JAVAAGENT} ${APPD_PROPERTIES} ${JMX_OPTS} -Djava.util.logging.config.file=/usr/local/tomcat/conf/logging.properties -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Djdk.tls.ephemeralDHKeySize=2048 -Djava.protocol.handler.pkgs=org.apache.catalina.webresources -javaagent:/opt/appdynamics/javaagent.jar -classpath /usr/local/tomcat/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar -Dcatalina.base=/usr/local/tomcat -Dcatalina.home=/usr/local/tomcat -Djava.io.tmpdir=/usr/local/tomcat/temp org.apache.catalina.startup.Bootstrap start
  ;;
portal)
  dockerize -wait tcp://rabbitmq:5672 \
            -wait tcp://rest:8080 \
            -wait-retry-interval ${RETRY} -timeout ${TIMEOUT} || exit $?

  cp /${PROJECT}/AD-Capital/Portal/build/libs/portal.war ${CATALINA_HOME}/webapps;
  cd ${CATALINA_HOME}/bin;
  /docker-java-home/jre/bin/java ${APPD_JAVAAGENT} ${APPD_PROPERTIES} ${JMX_OPTS} -Djava.util.logging.config.file=/usr/local/tomcat/conf/logging.properties -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Djdk.tls.ephemeralDHKeySize=2048 -Djava.protocol.handler.pkgs=org.apache.catalina.webresources -javaagent:/opt/appdynamics/javaagent.jar -classpath /usr/local/tomcat/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar -Dcatalina.base=/usr/local/tomcat -Dcatalina.home=/usr/local/tomcat -Djava.io.tmpdir=/usr/local/tomcat/temp org.apache.catalina.startup.Bootstrap start
  ;;
processor)
  dockerize -wait tcp://adcapitaldb:3306 \
            -wait tcp://rabbitmq:5672 \
            -wait tcp://rest:8080 \
            -wait-retry-interval ${RETRY} -timeout ${TIMEOUT} || exit $?

  cp /${PROJECT}/AD-Capital/Processor/build/libs/processor.war ${CATALINA_HOME}/webapps;
  cd ${CATALINA_HOME}/bin;
  /docker-java-home/jre/bin/java ${APPD_JAVAAGENT} ${APPD_PROPERTIES} ${JMX_OPTS} -Djava.util.logging.config.file=/usr/local/tomcat/conf/logging.properties -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Djdk.tls.ephemeralDHKeySize=2048 -Djava.protocol.handler.pkgs=org.apache.catalina.webresources -javaagent:/opt/appdynamics/javaagent.jar -classpath /usr/local/tomcat/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar -Dcatalina.base=/usr/local/tomcat -Dcatalina.home=/usr/local/tomcat -Djava.io.tmpdir=/usr/local/tomcat/temp org.apache.catalina.startup.Bootstrap start
  ;;
approval)
  dockerize -wait tcp://rabbitmq:5672 \
            -wait tcp://rest:8080 \
            -wait-retry-interval ${RETRY} -timeout ${TIMEOUT} || exit $?

  cd ${CATALINA_HOME}/bin;
  /docker-java-home/jre/bin/java ${APPD_JAVAAGENT} ${APPD_PROPERTIES} ${JMX_OPTS} -Djava.util.logging.config.file=/usr/local/tomcat/conf/logging.properties -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Djdk.tls.ephemeralDHKeySize=2048 -Djava.protocol.handler.pkgs=org.apache.catalina.webresources -javaagent:/opt/appdynamics/javaagent.jar -classpath /usr/local/tomcat/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar -Dcatalina.base=/usr/local/tomcat -Dcatalina.home=/usr/local/tomcat -Djava.io.tmpdir=/usr/local/tomcat/temp org.apache.catalina.startup.Bootstrap start
  ;;
verification)
  dockerize -wait tcp://adcapitaldb:3306 \
            -wait tcp://rabbitmq:5672 \
            -wait tcp://rest:8080 \
            -wait-retry-interval ${RETRY} -timeout ${TIMEOUT} || exit $?

  cd ${CATALINA_HOME}/bin;
  /docker-java-home/jre/bin/java ${APPD_JAVAAGENT} ${APPD_PROPERTIES} ${JMX_OPTS} -Djava.util.logging.config.file=/usr/local/tomcat/conf/logging.properties -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Djdk.tls.ephemeralDHKeySize=2048 -Djava.protocol.handler.pkgs=org.apache.catalina.webresources -javaagent:/opt/appdynamics/javaagent.jar -classpath /usr/local/tomcat/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar -Dcatalina.base=/usr/local/tomcat -Dcatalina.home=/usr/local/tomcat -Djava.io.tmpdir=/usr/local/tomcat/temp org.apache.catalina.startup.Bootstrap start
  ;;
*)
  echo "ROLE missing: container will exit"; exit 1
  ;;

esac
