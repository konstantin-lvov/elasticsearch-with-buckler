FROM openjdk:12-jdk

ENV ELASTIC_VERSION=5.5.3
ENV HOST_NETWORK=0.0.0.0
ENV ELASTIC_INSTALL_DIR=/home/elastic/elasticsearch-$ELASTIC_VERSION

RUN useradd -ms /bin/bash elastic
WORKDIR /home/elastic
USER elastic

#########################
# install elasticsearch #
#########################

RUN curl -L -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$ELASTIC_VERSION.tar.gz && tar -xvf elasticsearch-$ELASTIC_VERSION.tar.gz

WORKDIR $ELASTIC_INSTALL_DIR

COPY elasticsearch.yml $ELASTIC_INSTALL_DIR/config

COPY entrypoint.sh $ELASTIC_INSTALL_DIR

ENTRYPOINT ["./entrypoint.sh"]

###################
# install buckler #
###################

USER root
RUN mkdir -p $ELASTIC_INSTALL_DIR/config/buckler && chown -R elastic:elastic $ELASTIC_INSTALL_DIR && chmod -R 766 $ELASTIC_INSTALL_DIR
USER elastic

RUN $ELASTIC_INSTALL_DIR/bin/elasticsearch-plugin install -b https://packages.atlassian.com/maven/com/atlassian/elasticsearch/buckler-plugin/1.0.4/buckler-plugin-1.0.4-5.5.3.zip

COPY buckler.yml $ELASTIC_INSTALL_DIR/config/buckler

RUN ls -la $ELASTIC_INSTALL_DIR/config/buckler



