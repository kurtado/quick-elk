quick-elk
=========

Install and run an ELK stack on your laptop, lickety-split!

Now featuring Kibana 4... Hope you enjoy it... Play around a bit and let me know of any issues. Thanks!

Quick Install
=============
Simply clone this repo and run install.sh. It will automatically download versions of Elasticsearch, Logstash and Kibana and install them into the local location of this repo. (Kibana will be installed as an Elasticsearch plugin). If you want to overrie the install location supply it as the first command line parameter when invoking the script.

The install script will also ingest a dataset containing 2012 NFL play-by-play data, plus install a very basic Kibana dashboard (containing only one row + panel).

To re-ingest the NFL data, run this command (or similar, depending on path, etc):

  cat 2012_nfl_pbp_data.csv| ./logstash-1.4.2/bin/logstash -f nfl.conf

Apache Logs
===========
This bundle also includes a configuration allowing easy ingestion of Apache webserver logs into Elasticsearch via Logstash. Simply place a file called `logs` in the directory and run the following command:

  ./logstash-1.4.2/bin/logstash -f apachelog.conf < logs

Note that the `logs` file must be in the Apache Combined log format for this to run out-of-the-box.

Twitter Streaming API
=====================
Another interesting out-of-the-box demo is possible using the `twitter.conf` Logstash configuration file. You'll need to acquire your Twitter credentials by visiting http://dev.twitter.com/ and creating an application via the "My Applications" link. Substitute your twitter oAuth credentials for the placeholders in the twitter.conf file, and run:

  ./logstash-1.4.2/bin/logstash -f twitter.conf

This will populate an Elasticsearch index called "tweets" with tweet data. To change the twitter keywords, simply modify the `keywords` array in the configuration file.
 
