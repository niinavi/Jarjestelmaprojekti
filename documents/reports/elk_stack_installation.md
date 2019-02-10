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

## Configuring Logstash


-------------------------------------------------------------------------------------


Some sources I used in this report. 

https://www.digitalocean.com/community/tutorials/how-to-install-elasticsearch-logstash-and-kibana-elastic-stack-on-ubuntu-18-04 

https://www.elastic.co/guide/en/logstash/current/getting-started-with-logstash.html

https://www.elastic.co/guide/en/elasticsearch/reference/current/getting-started-install.html

