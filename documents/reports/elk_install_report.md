# Installing ELK Stack on Ubuntu 18.04

Purpose is to install ELK-stack on Ubuntu 18.04. 

The ELK stack combines Elasticsearch, Logstash, and Kibana into a simple, yet powerful, open source stack that lets you manage large amounts of logged data.

Source: https://linuxconfig.org/install-elk-on-ubuntu-18-04-bionic-beaver-linux

Installation is done using Vagrant box.

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

check that folder is correct:
```
sudoedit /etc/nginx/sites-enabled/kibana
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

Check Kibana is running
```
netstat -plntu
tcp        0      0 127.0.0.1:5601          0.0.0.0:*               LISTEN  
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

## Testing Kibana
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
```
localhost:8080

result
502 Bad Gateway
```

Kibana was not up and running, started kibana.

Retry from host web browser, localhost:8080 -->
Kibana server is not ready yet

Restarting VM helped to problem.

