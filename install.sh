#!/bin/bash

INSTALL_DIR=${1:-`dirname $0`/elk}
LOGSTASH_PATH=logstash-1.4.2
LOGSTASH_BINARY=$LOGSTASH_PATH.tar.gz
ES_PATH=elasticsearch-1.4.4
ES_BINARY=$ES_PATH.tar.gz
NFL_DATA_FILE_NAME=2012_nfl_pbp_data.csv
NFL_DATA_BINARY=2012_nfl_pbp_data.csv.gz
KIBANA_VERSION=kibana-4.0.1
KIBANA_OS="`uname | tr '[:upper:]' '[:lower:]'`-x64"
KIBANA_BINARY=$KIBANA_VERSION-$KIBANA_OS

echo Installing ELK stack into $INSTALL_DIR
mkdir -p $INSTALL_DIR

cp twitter.conf $INSTALL_DIR
cp nfl.conf $INSTALL_DIR
cp week-by-week.json $INSTALL_DIR
cp $NFL_DATA_BINARY $INSTALL_DIR
cp populate_kibana.sh $INSTALL_DIR

cd $INSTALL_DIR
if test -s $LOGSTASH_BINARY
then
    echo Logstash already Downloaded
else
	echo Downloading logstash 1.4.2
 	curl -O https://download.elasticsearch.org/logstash/logstash/$LOGSTASH_BINARY
fi

if test -s $ES_BINARY
then
    echo Elasticsearch already Downloaded
else
	echo Downloading $ES_PATH
	curl -O https://download.elasticsearch.org/elasticsearch/elasticsearch/$ES_BINARY
fi

echo Downloaded... Now installing
echo Unpacking logstash
tar zxf $LOGSTASH_BINARY

echo Unpacking Elasticsearch
tar zxf $ES_BINARY

pwd
echo Unpacking nfl dataset
gunzip -f $NFL_DATA_BINARY

cd $ES_PATH
if [ -d "plugins/marvel" ];
then
    echo Marvel already installed
else
	echo Installing Marvel latest
	bin/plugin -i elasticsearch/marvel/latest
fi

if [ -d "plugins/kopf" ];
then
    echo kopf already installed
else
	echo Installing kopf latest
	bin/plugin -i lmenezes/elasticsearch-kopf
fi

echo Starting Elasticsearch to run in the background.  
bin/elasticsearch -d --cluster.name=es_demo --number_of_shards=1 --number_of_replicas=0 --network.host=localhost

cd ..
pwd
if test -s $KIBANA_BINARY
then
    echo Kibana already Downloaded
else
	echo Downloading Kibana Latest
	curl -O https://download.elasticsearch.org/kibana/kibana/$KIBANA_BINARY.tar.gz
fi

if [ -d $KIBANA_BINARY ];
then
    echo Kibana already installed
else
	echo Installing Kibana latest	
	tar zxvf $KIBANA_BINARY.tar.gz
fi
./$KIBANA_BINARY/bin/kibana &

#cp ../week-by-week.json plugins/kibana/_site/app/dashboards/

pwd

./populate_kibana.sh
pwd

cd $LOGSTASH_PATH
echo loading nfl data using logstash
pwd
bin/logstash -f ../nfl.conf < ../$NFL_DATA_FILE_NAME

echo Now browse to:
echo  http://localhost:9200/_plugin/marvel
echo or
echo http://localhost:9200/_plugin/kopf
echo or
echo http://localhost:5601
echo or
echo http://localhost:5601/#/dashboard/NFL-2012?_g=%28time:%28from:%272012-08-31T18:35:39.050Z%27,mode:absolute,to:%272013-02-03T19:50:39.050Z%27%29%29

exit
