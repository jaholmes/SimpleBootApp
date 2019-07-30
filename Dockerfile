FROM openjdk:8

# Install required packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y unzip && \
    apt-get clean

ENV APPD_AGENT_VERSION 4.5.9.25648
ENV APPD_AGENT_SHA256 54a384e59b60462d249dc6faa84df030e6c0695c8f1e5da53f287d46c66cebe9

ENV APPDYNAMICS_AGENT_ACCOUNT_NAME=
ENV APPDYNAMICS_CONTROLLER_SSL_ENABLED=
ENV APPDYNAMICS_AGENT_TIER_NAME=SimpleBootApp
ENV APPDYNAMICS_AGENT_APPLICATION_NAME=SimpleBootApp
ENV APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY=
ENV APPDYNAMICS_CONTROLLER_HOST_NAME=
ENV APPDYNAMICS_CONTROLLER_PORT=
ENV APPDYNAMICS_NODE_PREFIX=SimpleBootApp
ENV JAVA_AGENT -javaagent:/opt/appdynamics/appagent/ver${APPD_AGENT_VERSION}/javaagent.jar

COPY AppServerAgent-${APPD_AGENT_VERSION}.zip /tmp

RUN mkdir -p /opt/appdynamics && mkdir /opt/appdynamics/appagent && \
    unzip -oq /tmp/AppServerAgent-${APPD_AGENT_VERSION}.zip -d /opt/appdynamics/appagent && \
    rm /tmp/AppServerAgent-${APPD_AGENT_VERSION}.zip 

RUN mkdir -p /simpleboot
COPY ./target/simplebootapp-0.0.1-SNAPSHOT.jar /simpleboot

CMD ["sh", "-c", "java $JAVA_AGENT ${APPDYNAMICS_NODE_PREFIX:+-Dappdynamics.agent.reuse.nodeName=true -Dappdynamics.agent.reuse.nodeName.prefix=${APPDYNAMICS_NODE_PREFIX}} -jar /simpleboot/simplebootapp-0.0.1-SNAPSHOT.jar"]
#-Dappdynamics.agent.uniqueHostId=$(sed -rn '1s#.*/##; 1s/(.{12}).*/\1/p' /proc/self/cgroup)
