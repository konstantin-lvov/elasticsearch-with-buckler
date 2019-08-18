FROM openjdk:12-jdk

ENV ELASTIC_VERSION=6.5.3
ENV HOST_NETWORK=192.168.0.102
ENV ELASTIC_INSTALL_DIR=/home/elastic/elasticsearch-$ELASTIC_VERSION
EXPOSE 9200
EXPOSE 9300

RUN useradd -ms /bin/bash elastic
WORKDIR /home/elastic
USER elastic

#########################
# install elasticsearch #
#########################

RUN curl -L -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$ELASTIC_VERSION.tar.gz

RUN tar -xvf elasticsearch-$ELASTIC_VERSION.tar.gz

WORKDIR $ELASTIC_INSTALL_DIR

COPY elasticsearch.yml $ELASTIC_INSTALL_DIR/config

RUN ls $ELASTIC_INSTALL_DIR/config

COPY entrypoint.sh $ELASTIC_INSTALL_DIR

#USER root
#RUN chmod 777 ./entrypoint.sh
#USER elastic

RUN ls -la $ELASTIC_INSTALL_DIR

ENTRYPOINT ["./entrypoint.sh"]

#RUN ./elasticsearch <---------x

###################
# install buckler #
###################

RUN $ELASTIC_INSTALL_DIR/bin/elasticsearch-plugin install -b https://packages.atlassian.com/maven/com/atlassian/elasticsearch/buckler-plugin/2.0.0/buckler-plugin-2.0.0-6.5.3.zip

RUN mkdir -p $ELASTIC_INSTALL_DIR/config/buckler

#https://packages.atlassian.com/maven/com/atlassian/elasticsearch/buckler-plugin/2.1.0/ #buckler-plugin-2.1.0-6.6.1.zip?_ga=2.159214458.1306081798.1566036814-1339799491.1566036814

COPY buckler.yml $ELASTIC_INSTALL_DIR/config/buckler

USER root
RUN chown -R elastic:elastic $ELASTIC_INSTALL_DIR/config/buckler
RUN chmod -R 777 $ELASTIC_INSTALL_DIR/config/buckler
COPY sysctl.conf /etc/
USER elastic


RUN ls -la $ELASTIC_INSTALL_DIR/config/buckler



