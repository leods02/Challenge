FROM centos:centos7

RUN yum -y update && \
    yum -y install wget tar java-11-openjdk-devel openssl

ENV JAVA_VERSION 17
RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
    "https://download.oracle.com/java/${JAVA_VERSION}/latest/jdk-17_linux-x64_bin.rpm" && \
    yum -y localinstall jdk-17_linux-x64_bin.rpm && \
    rm jdk-17_linux-x64_bin.rpm

ENV CATALINA_HOME /opt/tomcat
ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.5.100

RUN wget "https://mirror.linux-ia64.org/apache/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz" && \
    tar -xvf apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    rm apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    mv apache-tomcat-${TOMCAT_VERSION} ${CATALINA_HOME}

RUN wget https://tomcat.apache.org/tomcat-8.5-doc/appdev/sample/sample.war -P ${CATALINA_HOME}/webapps/

ADD server.crt ${CATALINA_HOME}/conf/
ADD server.key ${CATALINA_HOME}/conf/

RUN openssl pkcs12 -export -out ${CATALINA_HOME}/conf/keystore.p12 \
    -inkey ${CATALINA_HOME}/conf/server.key -in ${CATALINA_HOME}/conf/server.crt \
    -passout pass:changeit -name tomcat

RUN sed -i '/<\/Service>/i \
    <Connector \
          protocol="org.apache.coyote.http11.Http11NioProtocol" \
          port="4041" \
          maxThreads="200" \
          maxParameterCount="1000" \
          scheme="https" \
          secure="true" \
          SSLEnabled="true" \
          keystoreFile="/opt/tomcat/conf/keystore.p12" \
          keystoreType="PKCS12" \
          keystorePass="changeit" \
          clientAuth="false" \
          sslProtocol="TLS"/>' ${CATALINA_HOME}/conf/server.xml

EXPOSE 4041

CMD ["/opt/tomcat/bin/catalina.sh", "run"]

