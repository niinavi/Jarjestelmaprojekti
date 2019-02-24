# ELK stack installation

I installed ELK Stack and Nginx. First I tried to approach with Apache but I didn't make the configuration work.
I installed it on VirtualBox with Ubuntu 18.04.1.0 LTS. 

The configuration of Logstash will be added later.

## Getting started
Install Java8  
```
$ sudo add-apt-repository ppa:webupd8team/java
$ sudo apt update
$ sudo apt update
```

Install Nginx  

```
$ sudo apt update
$ sudo apt install nginx
```
## Installing Elasticsearch

Import he Elasticsearch public GPG key  

```
$ wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
```

Add the Elastic source list to sources.list.d directory. Apt will look for new sources there. I didn’t fully understand this. In this command, the echo will print out the text inside quotation marks. The command ”tee” stores the output to the file elastic-6.x.list.

```
$ echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
```
```
$ sudo apt update
$ sudo apt install elasticsearch
```
start Elasticsearch  
```
$ sudo systemctl start elastic search
```

## Install Kibana
```
$ sudo apt install kibana
$ sudo systemctl start kibana
```

Add user and password for Kibana  
```
$ echo "kibanaadmin:`openssl passwd -apr1 mypassword`" | sudo tee -a /etc/nginx/htpasswd.kibana
```
Edit Kibana configuration kibana.yml  
```
server.host: ”localhost”
```

Create file  /etc/nginx/sites-available/kibanaconf  and add the text below  
```
server {
    listen 80;

    #server_name localhost;

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

Create a symlink  
```
$ sudo ln -s /etc/nginx/sites-available/kibanaconf /etc/nginx/sites-enabled/kibanaconf
```

Remove the default file from /etc/nginx/sites-enabled  
```
$ sudo rm /etc/nginx/sites-enabled/default
```

Restart Kibana  
```
$ sudo systemctl restart kibana
```

## Install Logstash 

```
$ sudo apt install logstash
```

**See if things are working**  
http://ip_address/status 

—> it should ask authorisation

**make Kibana and Elasticsearch to start every time the server boots:
```
$ sudo systemctl enable elasticsearch
$ sudo systemctl enable kibana
```

**Restrict access to Elasticsearch from outside and prevent reading data and shutting down via REST API**
```
sudo nano /etc/elasticsearch/elasticsearch.yml
```
```
$ network.host: localhost
```
## Connect from host’s web browser
- Make sure the VirtualBox network apapter is either Bridged Adapter or Host-only Adapter  
- Allow Nginx for ufw
```  
$ sudo ufw allow 'Nginx Full'
```

## Install Filebeat

I installed filedbeat with command
```
$ sudo apt-get update && apt-get install filebeat
```

I made confgirations to the filebeat.yml file with following. This way output uses logstash. I didn't specify TLS/SSL settings tbecause this is only a test installation.
```
filebeat.input:
- type: log
  paths:
    - /var/nginx/access.log 
	
enable true

output.logstash:
  hosts: ["localhost:5044"]
```

Install template:
```
$ sudo filebeat setup --template -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["localhost:9200"]'
```

To set up kibana dashboards, you can fing more information here: 
https://www.elastic.co/guide/en/beats/filebeat/6.6/load-kibana-dashboards.html 

Enabling Filebeat modules.

```
$ sudo filebeat modules enable system
$ sudo ./filebeat -e -c /etc/logstash/filebeat.yml -d "publish" 
```

Start the filebeat with following command.
```
$ sudo filebeat -e -c filebeat.yml -d "publish"
```

## Logstash configuration

I named logstash configuration file first-pipeline.conf and it is located in /usr/share/logstash.
```
input {
	beats {
		port => "5044"
		}
}
#filter {
#
#}

output {
	stdout { codec => rybydebug }
}
```


Start the filebeat with following command.
```
$ sudo filebeat -e -c filebeat.yml -d "publish"
```

Verify logstash using command below:
```
$ bin/logstash -f first-pipeline.conf --config.test_and_exit
```

I got an error  "/usr/share/logstash/data,must be a writable directory."
To fix this I made quick changes to permissions:
```
$ chmod 777 -R /usr/share/logstash/data
```

If the configuration file passes the verification, start Logstash with the following command:
```
$ sudo bin/logstash -f first-pipeline.conf --config.reload.automatic
```


## Sending logs to Elasticsearch

I added grok filter to the first-pipeline.conf file.  
The grok filter plugin is one of several plugins that are available by default in Logstash.
The grok filter plugin enables you to parse the unstructured log data into something structured.


```
input {
	beats {
		port => "5044"
		}
}
filter {
	grok {
		match =>  {"message" => "%{COMBINEDAPACHELOG}"}
	}
}

output {
    elasticsearch {
        hosts => [ "localhost:9200" ]
    }
}
```
I verified configuration and started logstash.

```
$ bin/logstash -f first-pipeline.conf --config.test_and_exit
$ sudo bin/logstash -f first-pipeline.conf --config.reload.automatic
```

The connection is visible on host's browser when I logged in Kibana dashboard. Kibana will show indeces about actions with date "logstash-2019.02.21". In the monitoring section, you can see it is connected. 


-------------------------------------------------------------------------------------


Some sources I used in this report. 

https://www.digitalocean.com/community/tutorials/how-to-install-elasticsearch-logstash-and-kibana-elastic-stack-on-ubuntu-18-04 

https://www.elastic.co/guide/en/logstash/current/getting-started-with-logstash.html

https://www.elastic.co/guide/en/elasticsearch/reference/current/getting-started-install.html

