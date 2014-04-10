#!/bin/bash

INSTALL_DIR=$HOME/elk

echo Installing ELK stack into $INSTALL_DIR
mkdir -p $INSTALL_DIR

cd $INSTALL_DIR
curl -O https://download.elasticsearch.org/logstash/logstash/logstash-1.4.0.tar.gz
curl -O https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.0.1.tar.gz
curl -O https://download.elasticsearch.org/kibana/kibana/kibana-3.0.0.tar.gz

echo Downloaded... Now installing

tar zxvf logstash-1.4.0.tar.gz
tar zxvf elasticsearch-1.0.1.tar.gz
tar zxvf kibana-3.0.0.tar.gz

cd elasticsearch-1.0.1
bin/plugin -i elasticsearch/marvel/latest
bin/plugin -install lmenezes/elasticsearch-kopf
bin/elasticsearch -d

echo Now browse to http://localhost:9200/_plugin/marvel
echo or
echo Now browse to http://localhost:9200/_plugin/kopf

exit
