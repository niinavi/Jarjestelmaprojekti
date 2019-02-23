# Installing ELK Stack on Ubuntu 16.04

Purpose is to install ELK-stack later on Ubuntu 18.04. 

The ELK stack combines Elasticsearch, Logstash, and Kibana into a simple, yet powerful, open source stack that lets you manage large amounts of logged data.

Sources 

https://www.digitalocean.com/community/tutorials/how-to-install-elasticsearch-logstash-and-kibana-elastic-stack-on-ubuntu-16-04

https://linuxconfig.org/install-elk-on-ubuntu-18-04-bionic-beaver-linux

Installation is done using Vagrant box bento-16.04

## Install The Dependencies

Logstash doesn't support Java 10. Im using nginx in this set up instead of Apache.

```
$ sudo apt install openjdk-8-jre apt-transport-https wget nginx
```

## Add The Elastic Repository

Elastic provides a complete repository for Debian based systems that includes all three pieces of software. 
```
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
```
```
sudoedit /etc/apt/sources.list.d/elastic.list
deb https://artifacts.elastic.co/packages/6.x/apt stable main
```

Save and exit.

Update Apt
```
sudo apt update
```

## Install Elasticsearch and Kibana

```
sudo apt install elasticsearch kibana
```

Edit Kibana configuration file at /etc/kibana/kibana.yml

```
server.host: "localhost"
```

Restart Kibana and start up Elasticsearch

```
$ sudo systemctl restart kibana
$ sudo systemctl start elasticsearch
```

Check Kibana is running
```
netstat -plntu
tcp        0      0 127.0.0.1:5601          0.0.0.0:*               LISTEN  
```
 
 ### Test Elasticsearch
```
curl localhost:9200
```

```
{
  "name" : "p3-hPxe",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "Xtb4CzbUQqe-HccHJgpq6g",
  "version" : {
    "number" : "6.6.0",
    "build_flavor" : "default",
    "build_type" : "deb",
    "build_hash" : "a9861f4",
    "build_date" : "2019-01-24T11:27:09.439740Z",
    "build_snapshot" : false,
    "lucene_version" : "7.6.0",
    "minimum_wire_compatibility_version" : "5.6.0",
    "minimum_index_compatibility_version" : "5.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

## Set Up Nginx

Kibana is served through Nginx.

Generate password to Kibana using openssl, and write passworf to Kibana password file.

```
$ echo "admin:`openssl passwd -apr1 YourPassword`" | sudo tee -a /etc/nginx/htpasswd.kibana
```

## Configure Nginx sites available

```
sudoedit /etc/nginx/sites-available/kibana
```

```
server {
        listen 80;

        # server_name localhost;

        auth_basic "Restricted Access";
        auth_basic_user_file /etc/nginx/htpasswd.kibana;

        location / {
            proxy_pass http://localhost:5601;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_cache_bypass $http_upgrade;        
        }
    }
```

Remove default configuration

```
sudo rm /etc/nginx/sites-enabled/default
```

create a new symlink in sites-enabled for Kibana. 

```
$ sudo ln -s /etc/nginx/sites-available/kibana /etc/nginx/sites-enabled/kibana
```

restart Nginx

```
sudo systemctl restart nginx
```

## Install Logstash
```
$ sudo apt install logstash
```

## Testing Kibana / Nginx
```
curl localhost:80
<html>
<head><title>401 Authorization Required</title></head>
<body bgcolor="white">
<center><h1>401 Authorization Required</h1></center>
<hr><center>nginx/1.10.3 (Ubuntu)</center>
</body>
</html>
```
## Testing with Web browser from host machine

Using host machine web browser
```
localhost:8080
```

Kibana was not up and running, started kibana.

Retry from host web browser, localhost:8080 -->
Kibana server is not ready yet

Restarting VM helped to problem.

## Log file locations

Nginx
 
- /var/log/nginx

Kibana
 
- Log file location needs to be configured, no default log

Elasticsearch
  
- /var/log/elasticsearch

Logstash
   
- /var/log/logstash/logstash.log

## Configuration files and ports

Nginx
  
- /etc/nginx/sites-available/kibana      
- /etc/nginx/htpasswd.kibana   
- port: 80

Logstash
   
- /etc/logstash   
- Configuration files, including logstash.yml   
- /usr/share/logstash   
- Logstash installation directory where is /bin directory for running Logstash commands.   
- Port: 5044 for FileBeat
- Logstash does not store logs which FileBeat sends to it. 

Kibana

- /etc/kibana   
- Port 5601

Elasticsearch
  
- /etc/elasticsearch   
- Port for Logstash: 9200   
- Port for Kibana: 9200

FileBeat
   
- /etc/filebeat
- /etc/filebeat/modules.d

# Configuring Filebeat to Send Log Lines to Logstash

The Filebeat client is a lightweight, resource-friendly tool that collects logs from files on the server and forwards these logs to your Logstash instance for processing.

Source: https://www.elastic.co/guide/en/logstash/current/advanced-pipeline.html

Logstash and Filebeat are running on the same machine in this report...

This part of report is unfinished, bacause my old laptop is extremely slow and I can't run ELK-stack with pipeline on it. Update: after adding more memory to VM I managed to run whole stack and log pipeline in my local setup.

## First testing Logstash Pipeline

Test that Logstash is working.

```
bin/logstash -e 'input {stdin { } } output { stdout {} }'
```

Logstash adds timestamp and IP address information to the message. Exit Logstash by issuing a CTRL-D command in the shell where Logstash is running.

Result with input "Hello world!":

```
Hello World!
{
       "message" => "Hello World!",
      "@version" => "1",
    "@timestamp" => 2019-02-07T10:42:27.865Z,
          "host" => "vagrant"
}
```

## Install FileBeat

Source: https://www.elastic.co/guide/en/beats/filebeat/6.6/filebeat-getting-started.html

Because ELK-stack was installed with apt, it is easy now install FileBeat using also apt.

```
sudo apt-get update && sudo apt-get install filebeat
```

To configure Filebeat to start automatically during boot, run: 
```
sudo update-rc.d filebeat defaults 95 10
```

## Configure FileBeat

Configuration file is

```
/etc/filebeat/filebeat.yml
```

We can also use ready Filebeat modules and enable them.

```
/etc/filebeat/modules.d
$ sudo filebeat modules enable system
```

Configure path to log files and basic configuration. Following lines in configuration harvests access.log from the path /var/log/nginx/access.log.

```
filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /var/log/nginx/access.log 
```

Comment out these lines from filebeat.yml, we want output to Logstash, not elasticsearch

```
output.elasticsearch:
   hosts: ["localhost:9200"]
```

### Configure FileBeat to use Logstatsh

Uncomment these lines in filebeat.yml
```
output.logstash:
  hosts: ["localhost:5044"]
```

#### index templates (unclear)

In Elasticsearch, index templates are used to define settings and mappings that determine how fields should be analyzed.

We need to manually load template because we are using Logstash, and Elasticsearch in not enabled in FileBeat.

First you need to enable Elasticsearch by using the -E option. Logstash output is enabled. 

To load the template, use command

```
vagrant@vagrant:/etc/filebeat$ sudo filebeat setup --template -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["localhost:9200"]'
Loaded index template
```

#### Set up the Kibana dashboards (unclear)

To load dashboards when the Logstash output is enabled, you need to temporarily disable the Logstash output and enable Elasticsearch. 

sudo filebeat setup -e \
  -E output.logstash.enabled=false \
  -E output.elasticsearch.hosts=['localhost:9200'] \
  -E output.elasticsearch.username=filebeat_internal \
  -E output.elasticsearch.password=YOUR_PASSWORD \
  -E setup.kibana.host=localhost:5601

### Start filebeat

```
sudo systemctl start filebeat
```

another option is 

```
sudo filebeat -e -c filebeat.yml -d "publish
```

which one to use??? later one show input on stdout (screen).

#### View the sample Kibana dashboards

Data is not here yet, because we haven't configured pipeline. (FileBeat ->logsatsh -> Elasticsearch)

### Logstash configuration continues, setting up pipeline after FileBeat installation

Test FileBeat online, so that it reads log files we configured it to harvest.

```
sudo ./filebeat -e -c filebeat.yml -d "publish"
```

## Configuring Logstash for Filebeat Input

Create a Logstash configuration pipeline that uses the Beats input plugin to receive events from Beats.

```
mkdir /usr/share/logstash
```

create file test-pipeline.conf

```
input {
    beats {
        port => "5044"
    }
}
# The filter part of this file is commented out to indicate that it is
# optional.
# filter {
#
# }
output {
    stdout { codec => rubydebug }
}
```

To verify your Logstash configuration, run the following command:

```
bin/logstash -f test-pipeline.conf --config.test_and_exit
```

If OK start Logstash.

```
sudo bin/logstash -f test-pipeline.conf --config.reload.automatic
```

another command 

```
sudo systemctl start logstash
```


which one to use???

Sample output from logstash

```

	Publish event: {
  "@timestamp": "2019-02-07T12:53:56.343Z",
  "@metadata": {
    "beat": "filebeat",
    "type": "doc",
    "version": "6.6.0"
  },
  "message": "10.0.2.2 - admin [07/Feb/2019:12:53:55 +0000] \"GET / HTTP/1.1\" 502 182 \"-\" \"Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:65.0) Gecko/20100101 Firefox/65.0\"",
  "source": "/var/log/nginx/access.log",
  "offset": 37154,
  "prospector": {
    "type": "log"
  },
  "input": {
    "type": "log"
  },
  "beat": {
    "version": "6.6.0",
    "name": "vagrant",
    "hostname": "vagrant"
  },
  "host": {
    "name": "vagrant",
    "id": "142e17b1ffa097b7d116eda15b7fc5ef",
    "containerized": false,
    "architecture": "x86_64",
    "os": {
      "platform": "ubuntu",
      "version": "16.04.5 LTS (Xenial Xerus)",
      "family": "debian",
      "name": "Ubuntu",
      "codename": "xenial"
    }
  },
  "log": {
    "file": {
      "path": "/var/log/nginx/access.log"
    }
  }
}
```

## Sending logs  to Elasticsearch

Next step is to configure Logstash to send logs to Elasticsearch. I also added filter to logstash pipeline configuration.


```
# The # character at the beginning of a line indicates a comment. Use
# comments to describe your configuration.

input {
    beats {
        port => "5044"
    }
}

# The filter part of this file is commented out to indicate that it is
# optional.
# filter {
#
# }
filter {
    grok {
        match => { "message" => "%{COMBINEDAPACHELOG}"}
    }
}

output {
    elasticsearch {
        hosts => [ "localhost:9200" ]
    }
}
```

To verify your Logstash configuration, run the following command:

```
bin/logstash -f test-pipeline.conf --config.test_and_exit
```

After that I started FileBeat to separete terminal, and created transaction to nginx access.log using browser. 

I also started Logstash to another terminal using command in directory /usr/share/logstash

```
sudo bin/logstash -f test-pipeline.conf --config.reload.automatic
```


## Testing whole pipeline

My laptop is running out of memory, I can't continue testing. After adding memory to VM I managed to run this test.

Command to test that log data is at Elasticsearch
```
curl -XGET 'localhost:9200/logstash-$DATE/_search?pretty&q=response=200'
```

Result was no results for search. After modifying command to

```
curl -XGET 'localhost:9200/logstash-*/_search?pretty&q=response=200'
```
I got results from Elasticsearch

```
"message" : "10.0.2.2 - admin [07/Feb/2019:11:29:12 +0000] \"GET /plugins/inspector_views/index.css HTTP/1.1\" 200 702 \"http://localhost:8080/app/kibana\" \"Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:65.0) Gecko/20100101 Firefox/65.0\"",
          "tags" : [
            "beats_input_codec_plain_applied"
          ],
          "beat" : {
            "hostname" : "vagrant",
            "name" : "vagrant",
            "version" : "6.6.0"
          }
        }
      },
      {
        "_index" : "logstash-2019.02.07",
        "_type" : "doc",
        "_id" : "Gug9yGgBQm7cpbMJKQzi",
        "_score" : 1.2845117,
        "_source" : {
          "ident" : "-",
          "input" : {
            "type" : "log"
          },
          "response" : "200",
          "source" : "/var/log/nginx/access.log",
          "host" : {
            "id" : "142e17b1ffa097b7d116eda15b7fc5ef",
            "containerized" : false,
            "os" : {
              "platform" : "ubuntu",
              "family" : "debian",
              "codename" : "xenial",
              "version" : "16.04.5 LTS (Xenial Xerus)",
              "name" : "Ubuntu"
            },
            "name" : "vagrant",
            "architecture" : "x86_64"
          },
          "agent" : "\"Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:65.0) Gecko/20100101 Firefox/65.0\"",
          "verb" : "GET",
          "referrer" : "\"http://localhost:8080/app/kibana\"",
          "@timestamp" : "2019-02-07T13:50:18.608Z",
          "clientip" : "10.0.2.2",
          "offset" : 24004,
          "httpversion" : "1.1",
          "prospector" : {
            "type" : "log"
          },
          "log" : {
            "file" : {
              "path" : "/var/log/nginx/access.log"
            }
          },
          "auth" : "admin",
          "@version" : "1",
          "timestamp" : "07/Feb/2019:11:29:12 +0000",
          "request" : "/plugi
```




