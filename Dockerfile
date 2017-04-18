FROM livingstoneonline/tomcat
MAINTAINER Nigel Banks <nigel.g.banks@gmail.com>

LABEL "License"="GPLv3" \
      "Version"="0.0.1"

ENV SOLR_HOME=/opt/solr

ARG SOLR_VERSION="4.10.3"
ARG SOLR_DEPENDENCIES="log4j-1.2.17.jar slf4j-api-1.7.6.jar slf4j-log4j12-1.7.6.jar"
RUN curl -L http://archive.apache.org/dist/lucene/solr/${SOLR_VERSION}/solr-${SOLR_VERSION}.tgz | \
    tar -xzf - -C /tmp && \
    mkdir ${CATALINA_BASE}/webapps/solr && \
    cp /tmp/solr-${SOLR_VERSION}/dist/solr-${SOLR_VERSION}.war ${CATALINA_BASE}/webapps/solr.war && \
    unzip -o ${CATALINA_BASE}/webapps/solr.war -d ${CATALINA_BASE}/webapps/solr && \
    for dep in ${SOLR_DEPENDENCIES}; do \
        cp /tmp/solr-${SOLR_VERSION}/example/lib/ext/$dep ${CATALINA_BASE}/lib; \
    done && \
    curl -o ${CATALINA_BASE}/lib/commons-logging-1.1.2.jar \
    -L http://repo1.maven.org/maven2/commons-logging/commons-logging/1.1.2/commons-logging-1.1.2.jar && \
    mkdir ${SOLR_HOME} && \
    cp -a /tmp/solr-${SOLR_VERSION}/example/solr/*  ${SOLR_HOME}/ && \
    curl -L https://ftp.drupal.org/files/projects/apachesolr-7.x-1.8.tar.gz | \
    tar -xzf - -C /tmp && \
    chown -R tomcat:tomcat ${CATALINA_HOME} ${SOLR_HOME} && \
    rm -rf ${CATALINA_HOME}/webapps/*.war && \
    cleanup

COPY rootfs /

RUN chown -R tomcat:tomcat ${CATALINA_HOME} ${SOLR_HOME}
