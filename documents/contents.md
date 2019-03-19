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

Our baseline for this project is centralized management system in company's local area network. Wwe used Salt stack to automate installation of centralized log repository and minion installations. lasticsearch, Logstash and Kibana (ELK Stack) were installed on master server and FileBeat to minions to harvest logs.

To help testing we also made a test program to create content to log files. In project we desided to collect all Apache logs and system logs for Kibana log analysis. 

Platform we used, versions?

How we did testing and where?

Where is version control?



## ELK-Stack <a name="elk-stack"></a>

Manuaaliset asennukset tänne.

### Architecture <a name="architecture"></a></summary>

![ELK architecture](https://assets.digitalocean.com/articles/elk/elk-infrastructure.png)

<details>
    
<summary>Elasticsearch <a name="elasticsearch"></a></summary>

</details>

<details>
    
<summary>Logstash <a name="logstash"></a></summary>

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



</details>

<details>
    
<summary>Kibana <a name="kibana"></a></summary>

</details>

<details>
    
<summary>FileBeat <a name="filebeat"></a></summary>

</details>

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

Configure repository to get ELK-stack packages.
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

Log analysis can be done with Kibana. In our project main target was to automate ELK-stack installation, so we will introduce Kibana briefly.

### Kibana UI

Open Kibana from http://localhost:80 URL. You have to authenticate before you get in to Kibana.

![](https://raw.githubusercontent.com/niinavi/Jarjestelmaprojekti/master/documents/pics/kibana_welcome.png)

Picture X. Kibana start page.

### User interaction

Before starting to use Kibana amd to do some log analysis, it is good to understand typical user interaction flow.

![](https://raw.githubusercontent.com/niinavi/Jarjestelmaprojekti/master/documents/pics/user_interaction.png)

Picture X. Typical user interaction flow

Before satrting Kibana there should be data in Elasticsearch and Kibana should be made aware of Elasticsearch indexes. So the indexes should be configured. User have to also familiarize himself with the data. What is data, what data fields there are? After understanding data it is easier to start to do visualization. Then user can also create dashboards using visualizations he has done before. Dashboards create even better understanding of data. Process is iterative, data structute is changing, new data is available and new visualizations and dashboras are needed.

### Index pattern

Index patterns are used to identify Elasticsearch indexes. Index pattern is just string which match to ES indexes. Wildcards can be used.

In Management -> Index pattern screen, type: logstash-*, select @timestamp for time filter field and create. Index pattern for Kibana has been created.

### Discover

On Discovery page user can explore data interactively. User can perform searches on data and filter results. Also document data can be viewed.

It is important to set proper time range, otherwise result could be empty.

![](https://raw.githubusercontent.com/niinavi/Jarjestelmaprojekti/master/documents/pics/discovery.png)

Picture X. Discovery page with query results.

Queries can be free text searches, just type text to query field. Queries can eb various types, ranging from simple ones to more complex ones. Boolean searches, field searches, range seraches and Regex searches are possible.

### Visualize

Variety types of visualizations can be created on Visualize page like line, area, pie and bar charts, 

Create visualization by clicking Create a new visualization button. Select visualization type, select data source and build the visualization.

![](https://raw.githubusercontent.com/niinavi/Jarjestelmaprojekti/master/documents/pics/pie.png)

Picture X. Traffic to web site from different countries.

### Dashboard

Dashboards help user to bring visualizations to single page. Dashboards can be created in Dashboard page by clicking Create Dashborad button. After that user can select from stored visualizations. After adding all needed visualizations to Dashboards it can be saved and Dashborad is created.

## Conclusions  <a name="conclusions"></a>

# Sources

Sebenik, Craig & Hatch, Thomas 2015. Salt Essentials: Getting started with automation at scale. O.Reilly media.

SatlStack. Pillar Walkthrough. 2019. https://docs.saltstack.com/en/latest/topics/tutorials/pillar.html

SaltStack. The Top File. 2019. https://docs.saltstack.com/en/latest/ref/states/top.html

Karvinen, Tero 2018. Pkg-File-Service – Control Daemons with Salt – Change SSH Server Port. http://terokarvinen.com/2018/pkg-file-service-control-daemons-with-salt-change-ssh-server-port

