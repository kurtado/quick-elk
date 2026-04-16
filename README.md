quick-elk
=========

Install and run an ELK stack on your laptop, lickety-split!

Now featuring Kibana 4... Hope you enjoy it... Play around a bit and let me know of any issues. Thanks!

Quick Install
=============
Simply clone this repo and run install.sh. It will automatically download versions of Elasticsearch, Logstash and Kibana and install them in a local directory. (Kibana will be installed as an Elasticsearch plugin).

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
Another interesting out-of-the-box demo is possible using the `twitter.conf` Logstash configuration file. You'll need to acquire your Twitter credentials by visiting http://dev.twitter.com/ and creating an application via the "My Applications" link. Set your credentials as environment variables before running Logstash:

  export TWITTER_CONSUMER_KEY="your-key"
  export TWITTER_CONSUMER_SECRET="your-secret"
  export TWITTER_OAUTH_TOKEN="your-token"
  export TWITTER_OAUTH_TOKEN_SECRET="your-token-secret"
  ./logstash-1.4.2/bin/logstash -f twitter.conf

This will populate an Elasticsearch index called "tweets" with tweet data. To change the twitter keywords, simply modify the `keywords` array in the configuration file.

Security Notice
===============
This project is intended for **local development and demos only**. Please be aware of the following:

- The bundled ELK versions (Elasticsearch 1.4.4, Logstash 1.4.2, Kibana 4.0.1) are from 2014-2015 and contain **known security vulnerabilities**, including remote code execution (e.g., CVE-2015-1427). Do not expose these services to untrusted networks.
- Elasticsearch runs with **no authentication**. Any process on the machine can read, write, and delete all data.
- All communication between components uses **unencrypted HTTP**.
- **Never commit real API keys or secrets** to this repository. The `twitter.conf` file reads credentials from environment variables — do not replace them with hardcoded values.

For production use, upgrade to a current, supported ELK stack release with security features enabled.
 
