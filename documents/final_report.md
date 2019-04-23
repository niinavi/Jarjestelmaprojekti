# Log analysis -project

***ICT Infrastructure project, Spring 2019*** 
***Haaga-Helia University of Applied Science***

**Team Members**  
[Juha Immonen](https://github.com/immonju1)   
[Niina Villman](https://github.com/niinavi)

**Project supervisor**  
Petri Hirvonen












# Table of Contents

1. [Introduction](#introduction)
2. [ELK-Stack](#elk-stack)
    1. [Architecture](#architecture)
    2. [Elasticsearch](#elasticsearch)
    3. [Logstash](#logstash)
    4. [Kibana](#kibana)
    5. [FileBeat](#filebeat)
3. [Salt States](#salt-states)
    1. [What is Salt](#what-is) 
    2. [Architecture](#architecture2)
    3. [States craeted in ELK-stack project](#states)
    4. [Test application](#testisovellus)
4. [Installation scripts](#automation)
5. [Kibana User Interface](#analytics)
6. [Conclusions](#conclusions)

<a name="introduction"></a>
## 1. Introduction

The topic of this project is to create a small architecture for centralized logging. Our aim is to familiarize our team with the tools, collect log data and analyze it. The project is part of our studies in ICT-infrastructure project course.

Our team is interested in centralized log management and we think it is significant part of security and system operations. Our team does not have previous experience of the main components in the project.

In this project we will use the collection of open source tools, Elasticsearch, Logstash and Kibana (ELK Stack). Elasticsearch is the search engine and stores the data, Logstash processes the data and sends the data to Elasticseach and Kibana is a tool for visualization. We will use FileBeat to transfer the data to Logstash.

Our baseline for this project is centralized management system in company's local area network. We used SaltStack to automate installation of centralized log repository and minion installations. Elasticsearch, Logstash and Kibana (ELK Stack) were installed on master server and FileBeat to minions to harvest logs. We collected mainly Apache logs in our project.

We used Ubuntu 18.04 LTS operating system on bootable live USB stick. We tested the environment using USB sticks in school’s laboratory classroom. We used minion and master on separate machines. We created automated scripts and salt states to make the installation automatic and easier to repeat. The scripts, salt states and pillars are stored here: https://github.com/niinavi/Jarjestelmaprojekti/tree/master/srv   


<a name="elk-stack"></a>
# 2. ELK-Stack 

We installed ELK-Stack using following components and versions. We used ufw firewall which is default in Ubuntu.

Ubuntu 18.04.1 LTS
Elasticsearch: version '6.6.0'  
Logstash: version '1:6.6.0-1'  
Kibana: version '6.6.0'  
SaltStack: 2017.7.4 (Nitrogen)  
Nginx: 1.14.0  
Java: openjdk version 1.8.0_191  

 <a name="architecture"></a></summary>
## 2.1 Architecture <a name="architecture"></a></summary>

Filebeat transfers the log data to Logstash that parses the data and sends it to Elasticsearch for storing and searching. Kibana is a dashboard for the user to examine the data and create visualizations. Nginx is used for accessing Kibana dashboard through proxy. 

In our project the architecture consisted of Filebeat, Logstash, Elasticsearch, Kibana and Nginx. We collected data from Apache logs on Minion and transferred them into Logstash on our Master. We also collected System logs but decided to focus on Apache logs when we explored Kibana dashboard. Apache and Filebeat are installed on our minion and on our master, Logstash, Elasticsearch and Kibana working together with Nginx. 

![ELK architecture](https://github.com/niinavi/Jarjestelmaprojekti/blob/master/documents/pics/elk-stack-server.png) 
Picture 1. ELK-architecture (Picture adapted from DigitalOcean Inc 2019a).

<a name="elasticsearch"></a>
## 2.2 Elasticsearch 

Elasticsearch is a search engine and for data storing. You don’t use it on its own because you need something to feed the data into and interface for users to search data. Elasticsearch indexes your data which helps you to make faster searches. For this purpose Elasticsearch uses a library called Lucene. (Gheorghe, Hinman & Russo, 2016, Chapter 1.)

"Finally, Elasticsearch is, as the name suggests, elastic. It’s clustered by default—you call it a cluster even if you run it on a single server—and you can always add more servers to increase capacity or fault tolerance. Similarly, you can easily remove servers from the cluster to reduce costs if you have lower load. " (Gheorghe ym. 2016, Chapter 1.)


### Configuration

Elasticserach uses JSON format for expressing data structures because it is easy for applications to parse and generate. The configuration files uses YAML (YAML Ain’t Markup Language).  Elasticsearch listens http port 9200 by default. (Gheorghe ym. 2016, Chapter 1.)

### Installation

For installation we need public GPG key and package repository with following commands. (DigitalOcean Inc 2019b.)
```
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list

```
The installation happens with command:
```
sudo apt install elasticsearch
```


<a name="logstash"></a>
## 2.3 Logstash

Logstash is a tool to centralize, transform and stash your data. Logstash processes Events. Event processing pipeline has three stages, input, filtering and output. These pipelines are usually stored in etc/logstash/conf.d directory. (Elasticsearch B.V. 2019a)

You can run multiple pipelines in the same process. It is useful if the configuration has event flows that don’t share the same inputs, filters or outputs. Enabling multiple pipelines is done through configuration file pipelines.yml that is places in the path.settings folder. (Elasticsearch B.V. 2019b)

![Logstash pipeline](https://github.com/niinavi/Jarjestelmaprojekti/blob/master/documents/pics/logstash-pipeline.png)
Picture 2. Logstash pipeline. (Picture adapted from Elasticsearch B.V. 2019c).

Inputs

Inputs define how data gets into Logstash. Logstash has different kinds of input mechanisms. Logstash can take inputs for example from TCP/UDP, files, Syslog, Microsoft Windows EventLogs, STDIN.  Input configuration is defined in the pipeline.yml file. In our test environment we use Filebeat to transfer data to Logstash. (Turnbull 2015, chapter "Introduction or Why Should I Bother?".)

Filters

Filters make possible to modify, manipulate and transform those events. There is large amount of filters and plugins to use. A few examples of filter plugins are grok for parsing and structurizing text, mutate for field manipulation and drop for dropping events (Elasticsearch B.V. 2019d).  With filters, you can separate the information you need from the log events. (Turnbull 2015, chapter "Introduction or Why Should I Bother?".)

Outputs

Outputs send the event data to the defined output. Logstash supports variety of different outputs, for example TCP/UDP, email, files for writing event data to a file on disk, HTTP and Nagios.  In our test environment we used Elasticsearch as an output for storing and managing the data. (Turnbull 2015, chapter "Introduction or Why Should I Bother?".)

### Configuration

Logstash configuration uses YAML. In our project we didn't make changes to the YAML file.  We created a pipeline and the pipeline configuration you can see [here](https://github.com/niinavi/Jarjestelmaprojekti/blob/master/srv/salt/logstash/systems.conf).

### Installation

Logstash requires Java 8. To check your Java version you need to run command ``` java -version```. To install Logstash you need to have had Public Signing Key and package repository installed with following commands. (DigitalOcean Inc 2019b.)
```
$ wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
$ sudo apt-get install apt-transport-https
$ echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
``` 
To install Logstash use following command.
```
$ sudo apt-get update && sudo apt-get install logstash
```

<a name="kibana"></a>
## 2.4 Kibana 

Kibana is developed by Elastic and is part of the ELK Stack package. Kibana is a platform for visualization and it is meant to work with Elasticsearch. To have a better understanding of Kibana you need to understand Elasticsearch since it is built upon it. (Gupta 2015, Chapter 1.)

Visualization is done through Visualize Page where you can create, modify and view visualizations. Basic use of aggregations used in Elasticsearch is the core of Kibana functionality.  Aggregations means the collections of data which are stored in buckets. Buckets store documents and they group the documents. (Gupta 2015, Chapter 3.)


### Configuration

Kibana configuration is made in YAML configuration file that is located in /etc/kibana directory. In our project we added only one line in Kibana configuration file that was “server.host: “localhost””. However we needed Nginx installed because we access to Kibana platform via web browser. We used Kibana through Nginx proxy and created Nginx user and password for the user.  Kibana listens port 5601 by default. 

### Installation

Followed instructions on DigitalOcean. For the installation you need also the package repository installed like with previous installations with other components.  You can install and start Kibana with following commands.(DigitalOcean Inc 2019b.)

```
sudo apt install kibana
sudo systemctl start kibana
```
We need to add user and password for Kibana to Nginx password file.

```
echo "kibanaadmin:`openssl passwd -apr1 mypassword`" | sudo tee -a /etc/nginx/htpasswd.kibana
```

We added following line to Kibana configuration file to add server host to be a localhost.
```
server.host: ”localhost”
```
In Nginx sites-available folder we need configuration file for Kibana and Proxy. The file will look like following. We specify that the port Nginx listens is 80 and the access will be restricted and the htpaswd.kibana file will contain the correct credentials for authentication. 
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
We need to create a symlink to Nginx sites-enabled directory and remove the default symbolic link in there.
```
sudo ln -s /etc/nginx/sites-available/kibanaconf /etc/nginx/sites-enabled/kibanaconf

sudo rm /etc/nginx/sites-enabled/default

sudo systemctl restart kibana
```

<a name="filebeat"></a>
## 2.5 FileBeat 

Filebeat is lightweight shipper for logs. The Filebeat client is resource-friendly tool that collects logs from files on the server and forwards these logs to your Logstash instance for processing. For the installation we have followed instructions on DigitalOcean. (DigitalOcean Inc 2019b.)

### Installation

Filebeat can be installed with apt-get when Elastic repository is added.

    sudo apt-get update && apt-get install filebeat

### Configuration to collect logs

Filebeat configuration file is filebeat.yml 

    /etc/filebeat/filebeat.yml

We configured Filebeat to forward Apache2 logs to logstash.

Following lines in configuration file filebeat.yml configures Filebeat to collect Apache2 access.log from the path /var/log/apache2/access.log.

```
filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /var/log/apache2/logs/access.log 
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

Start the filebeat with following command.

```
    sudo filebeat -e -c filebeat.yml -d "publish"
```

<a name="salt-states"></a>
# 3. Salt States 

<a name="what-is"></a>

## 3.1 What is Salt 

Salt is a remote execution framework and configuration management system. Salt is build to solve problem, how to manage multiple servers whether it is 2 or 10 000 machines. Salt design is basic master - client architecture. One server is master and minions can be many. Master server controls minions. (Sebenik & Hatch 2015, Chapter 1.)

Default configuration uses standard data format, yaml. Salt states are only text written in yaml format. That gives a great benefit, states can be versioned. It is also declarative model, states are not list of imperatice commands. Salt keeps minions in desired state after original installation. Desired states are at Salt state files. (Sebenik & Hatch 2015, Chapter 1.)

In our project we used Salt to automatically install ELK-stack on wanted machines.

<a name="architecture2"></a>

## 3.1 Architecture 

Salt design is basic master/client model. Salt runs as deamons or background processes on servers. Master and minion are communicating with ZeroMQ databus, where master publish commands and minions check if there are events for them to fullfill. Master check whether all required minions have done required actions. Minions also send data back to master using another port. (Sebenik & Hatch 2015, Chapter 1.)

![Salt acrhitecture](https://github.com/niinavi/Jarjestelmaprojekti/blob/master/documents/pics/salt-architecture.png)

Picture 3. Salt architecture (Sebenik & Hatch 2015, Chapter 1). 

Master provides a port to minions where minions can bind and watch for commands. Master server is most valuable server in network, because it can control all minions (Sebenik & Hatch 2015, Chapter 1).

All minions have unique id called minin ID. They also have to know master IP address.  Minion listens Master port and waits for events. Minions can also send data back to master. (Sebenik & Hatch 2015, Chapter 1.) Minions can be behind firewalls or NAT networks. (Karvinen 2018).

Pillars allow confidential, targeted data to be securely send to spesific minion. (Pillar Walkthrough 2019) Usually pillars are used to store passwords, user accounts and other sensitive data.

Usually infrastructure is made up of groups of servers, and each server in the group is performing a role similar to others (The Top File 2019). File which contains mappings between role and server is called top file (The Top File 2019). Minion which ID or other feature, like grains, is matching top file configuration will apply state(s) that are defined in top file (The Top File 2019).

<a name="states"></a>

## 3.2 States created in ELK-stack project

Our Salt states are on GitHub
[Salt states](https://github.com/niinavi/Jarjestelmaprojekti/tree/master/srv/salt)

We followed Pkg-file-service pattern in our Salt states, each state will install package, configure it and run it as service. Service means that Salt is following changes in configurations, and it does restart to service if configuration has changed. (Karvinen 2018.)

We will explain states in next chapters briefly because code itself should be self declarative. 

### Master server states

Master server works in our setup as centralized log storage, where logs are stored and analyzed. Logstash, Elasticsearch and Kibana should be installed on master server.

Installing dependencies with Java
- state: java

Configure repository to get ELK-stack packages.
- state: elk-pkg

States to install ELK-stack
- States: elastic, logstash, kibana

Nginx is used as proxy to Kibana and it is installed using nginx-state
- state: nginx

Firewall rules for master server
- state: firewall

### Minions states

Minion servers will harvest and send logs to centralized log repository. We use FileBeat for log harvesting. 

Small test Web program which is using database is also installed to minions to test LAMP stack. Test program is coded with PHP, it runs on Apache and uses MariaDB. Apache state also implements Apche virtual host name for testing purposes. 

Add Elastic repository.
- state: elk-pkg

FileBeat installation
- state: filebeat

Apache and test Web application installation:
- state: apache 

MariaDB installtion
- state: mariadb

### top.sls

Top.sls contains two roles, master and elk. Those are used to control what is installed to master server and what to minions.

top.sls:
```
base:
  'minion':
    - elk-pkg
    - apache
    - mariadb
    - filebeat
    
  'master':
    - firewall
    - java
    - elk-pkg
    - elastic
    - kibana
    - nginx
    - logstash
```

### Pillars

Pillars are used to store secrets. Installation script master.sh writes Kibana user password and Master IP to secrets.

Pillars are stored to /srv/pillar directory
- server.sls
- filebeat.sls

<a name="testisovellus"></a>

## 3.3 Test application 

Test application is simple PHP program which uses MariaDB database. Source code can be found [here](https://github.com/niinavi/Jarjestelmaprojekti/tree/master/srv/salt/apache/php). Users can read, update, delete and insert new books to database.

After installation, the test program can be found on minions via URL: http://localhost:80/php or http://juha.example.com/php

<a name="automation"></a>

# 4. Installation scripts  

ELK-stack can be installed using automation. We created scripts to install Salt master and minion for those servers where needed. After Salt installation states can be applied to minions with Salt.

Master server should be only one server, but minion can be installed on many different servers. Logs are harvested from minions by FileBeat and collected to master server where is Logstash, Elasticsearch and Kibana installed.

Master should be installed first and minions after that. Master server IP-address is needed during installation.

## 4.1 Automatic installation scripts

Installation has been tested in Ubuntu 18.04.1 LTS. 

###  Install Salt Master

During installation scripts asks input form user. Kibana user password should be given during installation.

```
wget https://raw.githubusercontent.com/niinavi/Jarjestelmaprojekti/master/srv/master.sh
chmod g+x master.sh
sudo ./master.sh
```

### Install Salt Minion

During installation scripts asks input form user. Master IP-address and minion ID should be given.

```
wget https://raw.githubusercontent.com/niinavi/Jarjestelmaprojekti/master/srv/minion.sh
chmod g+x minion.sh
sudo ./minion.sh
```

### Accept/validate Minion keys

Accept minion keys at Master.

```
sudo salt-key -A
```

### Run Salt states to minions

Salt minion is also installed to Master server so master is also a minion to itself. State will install Logstash, Elasticsearch and Kibana to master server.

```
sudo salt '*' state.highstate
```

Command runs all minions to desired state.

<a name="analytics"></a>

# 5. Kibana User Interface  

Log analysis can be done with Kibana. In our project main target was to automate ELK-stack installation, so we will introduce Kibana only briefly.

## 5.1 Kibana login

Open Kibana from http://localhost:80 URL. You have to authenticate before you get in to Kibana becose we are using nginx as an autentication proxy.

![](https://github.com/niinavi/Jarjestelmaprojekti/blob/master/documents/pics/kibana_welcome.png)

Picture 4. Kibana start page.

## 5.2 User interaction

Before starting to do some log analysis, it is good to understand typical user interaction flow in Kibana.

![](https://raw.githubusercontent.com/niinavi/Jarjestelmaprojekti/master/documents/pics/interactionflow2.png)

Picture 5. Typical user interaction flow (Shukla & Kumar 2017. Chapter Kibana UI).

When starting to use Kibana there should be data in Elasticsearch and Kibana should be made aware of Elasticsearch indexes. So the indexes should be configured. User have to also familiarize himself with the data. What is data, what data fields there are? After understanding data it is easier to start to do visualization. Then user can also create dashboards using visualizations he has done before. Dashboards create even better understanding of data. Process is iterative, data structute is changing, new data is available and new visualizations and dashboras are needed. (Shukla & Kumar 2017. Chapter Kibana UI.)

## 5.3 Index pattern

Index patterns are used to identify Elasticsearch indexes. Index pattern is just string which match to ES indexes. Wildcards can be used.

In Management -> Index pattern screen, type: logstash-*, select @timestamp for time filter field and create. Index pattern for Kibana has been created.

## 5.4 Discover

On Discovery page user can explore data interactively. User can perform searches on data and filter results. Also document data can be viewed.

It is important to set proper time range, otherwise result could be empty.

![](https://raw.githubusercontent.com/niinavi/Jarjestelmaprojekti/master/documents/pics/discovery.png)

Picture 6. Discovery page with query results.

Queries can be free text searches, just type text to query data. Queries can be various types, ranging from simple ones to more complex ones. Boolean searches, field searches, range seraches and Regex searches are possible.

## 5.5 Visualize

Variety forms of visualizations can be created on Visualize page like line, area, pie and bar charts. 

All visualization in Kibana is based on aggregation queries in Elasticserach. Aggregration provides multi-dimensional grouping of results. Aggregations are the key to understand how visualizations are done in Kibana. (Shukla & Kumar 2017. Chapter Kibana UI.)

This is not a deep dive to Kibana and aggregations, we just present simple way to start create visualizations.

### Metrics

Most basic metric is count, it returns count of documents. Other ones are average, min, max and median, few to mention. It is easiest to start from count like how many visits (count) there are on our web page. (Shukla & Kumar 2017. Chapter Kibana UI.)

### Buckets

Bucket means grouping of documents by common criteria. For example we can group visits to web site by origin countries. There are many types of buckets, simpliest is maybe terms. Terms works by grouping documents based on each unique term in the field. (Shukla & Kumar 2017. Chapter Kibana UI.)

### Create visualization

Before startting to create visualization select time range. Create visualization by clicking Create a new visualization button. Select visualization type, select data source and build the visualization.

![](https://raw.githubusercontent.com/niinavi/Jarjestelmaprojekti/master/documents/pics/pie.png)

Picture 7. Traffic to web site from different countries.

## 5.6 Dashboard

Dashboards help user to bring visualizations to single page. Dashboards can be created in Dashboard page by clicking Create Dashborad button. After that user can select from stored visualizations. After adding all needed visualizations to Dashboards it can be saved and Dashborad is created.

<a name="conclusions"></a><a name="conclusions"></a>

# 6. Conclusions  

We successfully installed the test environment and collected and analyzed data with ELK-Stack. We have only scratched the surface of centralized logging management and there’s plenty of things to learn with each components. We learnt the basics of ELK-Stack components, the installation, configuration and usage. We learnt to use SaltStack and shell scripting and Git version controlling with the project.

We could develop our project further creating a publicly visible website and collect data from it. Then we could get a lot of on time data for example, ip location etc. We could create multiple pipelines and learn how they work and use and familiarize ourselves with different filter plugins. We can continue to learn how ELK-Stack can benefit companies and understand the possible challenges.



# Sources

DigitalOcean Inc 2019a. How To Install Elasticsearch, Logstash, and Kibana (ELK Stack) on Ubuntu 14.04. URL: https://www.digitalocean.com/community/tutorials/how-to-install-elasticsearch-logstash-and-kibana-elk-stack-on-ubuntu-14-04 Accessed: 1 April 2019.

DigitalOcean Inc 2019b. How To Install Elasticsearch, Logstash, and Kibana (Elastic Stack) on Ubuntu 18.04 URL:https://www.digitalocean.com/community/tutorials/how-to-install-elasticsearch-logstash-and-kibana-elastic-stack-on-ubuntu-18-04 Accessed: 1 April 2019.

Elasticsearch B.V. 2019a. How Logstash Works. URL: https://www.elastic.co/guide/en/logstash/current/pipeline.html. Accessed: 31 March 2019.

Elasticsearch B.V. 2019b. Multiple pipelines. URL: https://www.elastic.co/guide/en/logstash/current/multiple-pipelines.html. Accessed: 31 March 2019.

Elasticsearch B.V. 2019c. Stashing your first event. URL: https://www.elastic.co/guide/en/logstash/current/first-event.html. Accessed: 31 March 2019.

Elasticsearch B.V. 2019d. Stashing your first event. URL: https://www.elastic.co/guide/en/logstash/6.6/filter-plugins.html. Accessed: 31 March 2019.

Gheorghe, Radu, Hinman, Matthew Lee & Russo, Roy 2016. Elasticsearch in action. Manning Publications Co. eBook.

Gupta, Yuvraj 2015. Kibana Essentials. Packt Publishing. eBook.

Karvinen, Tero 2018. Pkg-File-Service – Control Daemons with Salt – Change SSH Server Port. URL: http://terokarvinen.com/2018/pkg-file-service-control-daemons-with-salt-change-ssh-server-port. Accessed: 1 April 2019.

SatlStack. Pillar Walkthrough. 2019. https://docs.saltstack.com/en/latest/topics/tutorials/pillar.html

SaltStack. The Top File. 2019. https://docs.saltstack.com/en/latest/ref/states/top.html

Sebenik, Craig & Hatch, Thomas 2015. Salt Essentials: Getting started with automation at scale. O.Reilly media. eBook.

Shukla, Pranav & Kumar, Sharath 2017. Learning Elastic Stack 6.0. Packt. ebook.

The logstash book: log management made easy, Turnbull, James. ebook.

Turnbull, James (2015).The logstash book: log management made easy.  James Turnbull & Turnbull Press. eBook.




 


