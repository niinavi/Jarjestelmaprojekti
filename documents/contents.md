# Table of Contents

1. [Introduction](#introduction)
    1. [Purpose](#purpose)
2. [ELK-Stack](#elk-stack)
    1. [Architecture](#architecture)
    2. [Elasticsearch](#elasticsearch)
    3. [Logstash](#logstash)
    4. [Kibana](#kibana)
    5. [FileBeat](#filebeat)
3. [Salt States](#salt-states)
    1. [What is Salt](#what-is) 
    1. [Architecture](#architecture2)
    2. [Master](#master)
    3. [Minion](#minion)
4. [Installation](#installation)
5. [Log analytics with Kibana](#analytics)
6. [Conclusions](#conclusions)

## Introduction  <a name="introduction"></a>

The topic of this project is to create a small architecture for centralized logging. Our aim is to familiarize our team with the tools, collect log data and analyze it. The project is part of our studies in ICT-infrastructure project course.

Our team is interested in centralized log management and we think it is significant part of security and system operations. Our team does not have previous experience of the main components in the project.

In this project we will use the collection of open source tools, Elasticsearch, Logstash and Kibana (ELK Stack). Elasticsearch is the search engine and stores the data, Logstash processes the data and sends the data to Elasticseach and Kibana is a tool for visualization. We will use FileBeat to transfer the data to Logstash.

Our baseline for this project is centralized management system in company's local area network. Wwe used SaltStack to automate installation of centralized log repository and minion installations. Elasticsearch, Logstash and Kibana (ELK Stack) were installed on master server and FileBeat to minions to harvest logs. We collected mainly Apache logs in our project.

We used Xubuntu 18.04 operating system on bootable live USB stick. We tested the environment using USB sticks in school’s laboratory classroom. We used minion and master on separate machines. We created automated scripts and salt states to make the installation automatic and easier to repeat. The scripts, salt states and pillars are stored here: https://github.com/niinavi/Jarjestelmaprojekti/tree/master/srv   


Platform we used, versions?

How we did testing and where?

Where is version control?



## ELK-Stack <a name="elk-stack"></a>

Manuaaliset asennukset tänne.

### Architecture <a name="architecture"></a></summary>

Filebeat transfers the log data to Logstash that parses the data and sends it to Elasticsearch for storing and searching. Kibana is a dashboard for the user to examine the data and create visualizations. Nginx is used for accessing Kibana dashboard through proxy. 

In our project the architecture consisted of Filebeat, Logstash, Elasticsearch, Kibana and Nginx. We collected data from Apache logs on Minion and transferred them into Logstash on our Master. We also collected System logs but decided to focus on Apache logs when we explored Kibana dashboard. Apache and Filebeat are installed on our minion and on our master, Logstash, Elasticsearch and Kibana working together with Nginx. 

![ELK architecture](https://assets.digitalocean.com/articles/elk/elk-infrastructure.png)

### Elasticsearch <a name="elasticsearch"></a>

Elasticsearch is a search engine and for data storing. You don’t use it on its own because you need something to feed the data into and interface for users to search data.)Elasticsearch indexes your data which helps you to make faster searches. For this purpose Elasticsearch uses a library called Lucene. (Chapter 1, Introducing Elasticsearch)

??

### Configuration

Elasticserach uses JSON format for expressing data structures because it is easy for applications to parse and generate. The configuration files uses YAML (YAML Ain’t Markup Language).  Elasticsearch listens http port 9200 by default. (Elasticsearch in Action, Chapter 1. Introducing Elasticsearch)

### Installation

For installation we need public GPG key and package repository with following commands.
```
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list

```
The installation happens with command:
```
sudo apt install elasticsearch
```

### Logstash <a name="logstash"></a>

Logstash is a tool to centralize, transform and stash your data. Logstash processes Events. Event processing pipeline has three stages, input, filtering and output. These pipelines are usually stored in etc/logstash/conf.d directory. (https://www.elastic.co/guide/en/logstash/current/pipeline.html)

You can run multiple pipelines in the same process. It is useful if the configuration has event flows that don’t share the same inputs, filters or outputs. Enabling multiple pipelines is done through configuration file pipelines.yml that is places in the path.settings folder. (https://www.elastic.co/guide/en/logstash/current/multiple-pipelines.html)

KUVA TÄHÄN

Inputs

Inputs define how data gets into Logstash. Logstash has different kinds of input mechanisms. Logstash can take inputs for example from TCP/UDP, files, Syslog, Microsoft Windows EventLogs, STDIN.  Input configuration is defined in the pipeline.yml file. (The Logstash Book, Logstash design and architecture) In our test environment we use Filebeat to transfer data to Logstash.

Filters

Filters make possible to modify, manipulate and transform those events. There is large amount of filters and plugins to use. A few examples of filter plugins are grok for parsing and structurizing text, mutate for field manipulation and drop for dropping events (https://www.elastic.co/guide/en/logstash/6.6/filter-plugins.html).  With filters, you can separate the information you need from the log events. (The Logstash Book, Logstash design and architecture)

Outputs

Outputs send the event data to the defined output. Logstash supports variety of different outputs, for example TCP/UDP, email, files for writing event data to a file on disk, HTTP and Nagios.  In our test environment we used Elasticsearch as an output for storing and managing the data. (The Logstash Book, Logstash design and architecture)

### Configuration
link

### Installation

Logstash requires Java 8. To check your Java version you need to run command ``` java -version```. To install Logstash you need to have had Public Signing Key and package repository installed with following commands.
```
$ wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
$ sudo apt-get install apt-transport-https
$ echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
``` 
To install Logstash use following command.
```
$ sudo apt-get update && sudo apt-get install logstash
```

Book Source:
The logstash book: log management made easy,
Turnbull, James
E-kirja


### Kibana <a name="kibana"></a>




## FileBeat <a name="filebeat"></a>

Filebeat is lightweight shipper for logs. The Filebeat client is resource-friendly tool that collects logs from files on the server and forwards these logs to your Logstash instance for processing. (https://www.elastic.co/guide/en/logstash/current/advanced-pipeline.html)

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

# 3. Salt States <a name="salt-states"></a>

## 3.1 What is Salt <a name="what-is"></a>

Salt is a remote execution framework and configuration management system. Salt is build to solve problem, how to manage multiple servers whether it is 2 or 10 000 machines. Salt design is basic master - client architecture. One server is master and minions can be many. Master server controls minions. (Sebenik & Hatch 2015, 107.)

Default configuration uses standard data format, yaml. Salt states are only text written in yaml format. That gives a great benefit, states can be versioned. It is also declarative model, states are not list of imperatice commands. Salt keeps minions in desired state after original installation. Desired states are at Salt state files. (Sebenik & Hatch 2015, 130.)

In our project we used Salt to automatically install ELK-stack on wanted machines.

## 3.1.1 Architecture <a name="architecture2"></a>

Salt design is basic master/client model. Salt runs as deamons or background processes on servers. Master and minion are communicating with ZeroMQ databus, where master publish commands and minions check if there are events for them to fullfill. Master check whether all required minions have done required actions. Minions also send data back to master using another port. (Sebenik & Hatch 2015, 157-179.)

![Salt acrhitecture](https://raw.githubusercontent.com/niinavi/Jarjestelmaprojekti/master/documents/pics/salt_architecture.png)

Picture: Salt architecture (Sebenik & Hatch 2015, 130). 

## 3.1.2 Master

Master provides a port to minions where minions can bind and watch for commands. Master server is most valuable server in network, because it can control all minions (Sebenik & Hatch 2015).

## 3.1.3 Minion

All minions have unique id called minin ID. They also have to know master IP address.  Minion listens Master port and waits for events. Minions can also send data back to master. (Sebenik & Hatch 2015.) Minions can be behind firewalls or NAT networks. (Karvinen xxx).

## 3.1.4 Secrets aka Pillars

Pillars allow confidential, targeted data to be securely send to spesific minion. (Pillar Walkthrough 2019) Usually pillars are used to store passwords, user accounts and other sensitive data.

## 3.1.5 Top File

Usually infrastructure is made up of groups of machines, and each machine in the group is performing a role similar to others (The Top File 2019).

File which contains mappings between role and machine is called top file (The Top File 2019).

Minion which ID or other feature, like grains, is matching top file configuration will apply state(s) that are defined in top file (The Top File 2019).

## 3.2 States created in ELK-stack project

Our Salt states are on GitHub
[Salt states](https://github.com/niinavi/Jarjestelmaprojekti/tree/master/srv/salt)

We followed Pkg-file-service pattern in our Salt states, each state will install package, configure it and run it as service. Service means that Salt is following changes in configurations, and it does restart to service if configuration has changed. (Karvinen 2018.)

We will explain states in next chapters briefly because code itself should be self declarative. 

### 3.2.1 Master server states

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

### 3.2.2 Minions states

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

### 3.2.3 top.sls

Top.sls contains two roles, master and elk. Those are used to control what is installed to master server and what to minions.

top.sls:
```
base:
  'elk':
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

### 3.2.4 Pillars

Pillar are used to store secrets. Installation script master.sh writes Kibana user password and Master IP to secrets.

Pillars are stored to /srv/pillar directory
- server.sls
- filebeat.sls

## 3.3 Bookstore test application <a name="Testisovellus"></a>

Test application is simple PHP program which uses MariaDB database. Source code is at 
[](https://github.com/niinavi/Jarjestelmaprojekti/tree/master/srv/salt/apache/php)

Users can read, update, delete and insert new books to database.

URL on minions: localhost:80/php or juha.example.com/php

# 4. Automatic installation  <a name="installation"></a>

ELK-stack can be installed using automation. We created scripts to install Salt master and minion for those servers where needed. After Salt installation states can be applied to minions with Salt.

Master server should be only one server, but minion can be installed on many different servers. Logs are harvested from minions by FileBeat and collected to master server where is Logstash, Elasticsearch and Kibana installed.

Master should be installed first and minions after that. Master server IP-address is needed during installation.

## 4.1 Automatic installation scripts

Installation has been test in Ubuntu 18.04 LTS. 

### 4.1.1 Install Salt Master

During installation scripts asks input form user. Kibana user password should be given during installation.

```
wget https://raw.githubusercontent.com/niinavi/Jarjestelmaprojekti/master/srv/master.sh
chmod g+x master.sh
sudo ./master.sh
```

### 4.1.2 Install Salt Minion

During installation scripts asks input form user. Master IP-address and minion ID should be given.

```
wget https://raw.githubusercontent.com/niinavi/Jarjestelmaprojekti/master/srv/minion.sh
chmod g+x minion.sh
sudo ./minion.sh
```

### 4.1.3 Accept/validate Minion keys

Accept minion keys at Master.

```
sudo salt-key -A
```

### 4.1.4 Run Salt states to minions

Salt minion is also installed to Master server so master is also a minion to itself. State will install Logstash, Elasticsearch and Kibana to master server.

```
sudo salt '*' state.highstate
```

Command runs all minions to desired state.

## Log analytics with Kibana  <a name="analytics"></a>

Log analysis can be done with Kibana. In our project main target was to automate ELK-stack installation, so we will introduce Kibana only briefly.

### Kibana UI

Open Kibana from http://localhost:80 URL. You have to authenticate before you get in to Kibana.

![](https://raw.githubusercontent.com/niinavi/Jarjestelmaprojekti/master/documents/pics/kibana_welcome.png)

Picture X. Kibana start page.

### User interaction

Before starting to do some log analysis, it is good to understand typical user interaction flow in Kibana.

![](https://raw.githubusercontent.com/niinavi/Jarjestelmaprojekti/master/documents/pics/user_interaction.png)

Picture X. Typical user interaction flow (Shukla & Kumar 2017. Chapter Kibana UI).

When starting to use Kibana there should be data in Elasticsearch and Kibana should be made aware of Elasticsearch indexes. So the indexes should be configured. User have to also familiarize himself with the data. What is data, what data fields there are? After understanding data it is easier to start to do visualization. Then user can also create dashboards using visualizations he has done before. Dashboards create even better understanding of data. Process is iterative, data structute is changing, new data is available and new visualizations and dashboras are needed.

### Index pattern

Index patterns are used to identify Elasticsearch indexes. Index pattern is just string which match to ES indexes. Wildcards can be used.

In Management -> Index pattern screen, type: logstash-*, select @timestamp for time filter field and create. Index pattern for Kibana has been created.

### Discover

On Discovery page user can explore data interactively. User can perform searches on data and filter results. Also document data can be viewed.

It is important to set proper time range, otherwise result could be empty.

![](https://raw.githubusercontent.com/niinavi/Jarjestelmaprojekti/master/documents/pics/discovery.png)

Picture X. Discovery page with query results.

Queries can be free text searches, just type text to query data. Queries can be various types, ranging from simple ones to more complex ones. Boolean searches, field searches, range seraches and Regex searches are possible.

### Visualize

Variety forms of visualizations can be created on Visualize page like line, area, pie and bar charts. 

All visualization in Kibana is based on aggregation queries in Elasticserach. Aggregration provides multi-dimensional grouping of results. Aggregations are the key to understand how visualizations are done in Kibana. (Lähde )

This is not a deep dive to Kibana and aggregations, we just present simple way to start create visualizations.

#### Metrics

Most basic metric is count, it returns count of documents. Other ones are average, min, max and median, few to mention. It is easiest to start from count like how many visits (count) there are on our web page. (Lähde )

#### Buckets

Bucket means grouping of documents by common criteria. For example we can group visits to web site by origin countries. There are many types of buckets, simpliest is maybe terms. Terms works by grouping documents based on each unique term in the field. (Lähde )

#### Create visualization

Before startting to create visualization select time range. Create visualization by clicking Create a new visualization button. Select visualization type, select data source and build the visualization.

![](https://raw.githubusercontent.com/niinavi/Jarjestelmaprojekti/master/documents/pics/pie.png)

Picture X. Traffic to web site from different countries.

### Dashboard

Dashboards help user to bring visualizations to single page. Dashboards can be created in Dashboard page by clicking Create Dashborad button. After that user can select from stored visualizations. After adding all needed visualizations to Dashboards it can be saved and Dashborad is created.

## Conclusions  <a name="conclusions"></a>

# Sources

Karvinen, Tero 2018. Pkg-File-Service – Control Daemons with Salt – Change SSH Server Port. http://terokarvinen.com/2018/pkg-file-service-control-daemons-with-salt-change-ssh-server-port

Sebenik, Craig & Hatch, Thomas 2015. Salt Essentials: Getting started with automation at scale. O.Reilly media.

SatlStack. Pillar Walkthrough. 2019. https://docs.saltstack.com/en/latest/topics/tutorials/pillar.html

SaltStack. The Top File. 2019. https://docs.saltstack.com/en/latest/ref/states/top.html

Shukla, Pranav & Kumar, Sharath 2017. Learning Elastic Stack 6.0. Packt. ebook.



