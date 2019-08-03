FROM openjdk:8

# Install required packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y unzip && \
    apt-get clean

# Install Maven
ARG MAVEN_VERSION=3.3.9
ARG USER_HOME_DIR="/root"
RUN mkdir -p /usr/share/maven && \
curl -fsSL http://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar -xzC /usr/share/maven --strip-components=1 && \
ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
ENV MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"

RUN mkdir -p /simpleboot
COPY src /simpleboot/src
COPY pom.xml /simpleboot

RUN cd /simpleboot && /usr/bin/mvn install

ENV APPD_AGENT_VERSION 4.5.12.27094
ENV APPD_AGENT_SHA256 54a384e59b60462d249dc6faa84df030e6c0695c8f1e5da53f287d46c66cebe9
ENV JAVA_AGENT -javaagent:/opt/appdynamics/appagent/ver${APPD_AGENT_VERSION}/javaagent.jar

COPY scripts/start-app.sh /simpleboot
RUN chmod 755 /simpleboot/start-app.sh
COPY AppServerAgent-${APPD_AGENT_VERSION}.zip /tmp

RUN mkdir -p /opt/appdynamics && mkdir /opt/appdynamics/appagent && \
    unzip -oq /tmp/AppServerAgent-${APPD_AGENT_VERSION}.zip -d /opt/appdynamics/appagent && \
    rm /tmp/AppServerAgent-${APPD_AGENT_VERSION}.zip 

CMD ["sh", "-c", "/simpleboot/start-app.sh"]
#-Dappdynamics.agent.uniqueHostId=$(sed -rn '1s#.*/##; 1s/(.{12}).*/\1/p' /proc/self/cgroup)
