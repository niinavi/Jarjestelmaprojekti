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

## ELK-Stack <a name="elk-stack"></a>

Manuaaliset asennukset tänne.
<details>
    
<summary>Architecture <a name="architecture"></a></summary>

</details>

<details>
    
<summary>Elasticsearch <a name="elasticsearch"></a></summary>

</details>

<details>
    
<summary>Logstash <a name="logstash"></a></summary>

</details>

<details>
    
<summary>Kibana <a name="kibana"></a></summary>

</details>

<details>
    
<summary>FileBeat <a name="filebeat"></a></summary>

</details>

# 3. Salt States <a name="salt-states"></a>

## 3.1 What is Salt

Salt is a remote execution framework and configuration management system. Salt is build to solve problem, how to manage multiple servers whether it is 2 or 10 000 machines. Salt design is basic master - client architecture. One server is master and minions can be many. Master server controls minions. (source)

Default configuration uses standard data format, yaml. Salt states are only text written in yaml format. That gives a great benefit, states can be versioned. It is also declarative model, states are not list of imperatice commands. Salt keeps minions in desired state after original installation. Desired state are at Salta state files. (source)

In our project we used Salt to automatically install ELK-stack on wanted machines.

## 3.1.1 Architecture <a name="architecture2"></a>

Salt design is basic master/client model. 

Salt runs as deamons or background processes on servers.

![Salt acrhitecture](https://raw.githubusercontent.com/niinavi/Jarjestelmaprojekti/master/documents/pics/salt_architecture.png)

Picture: Salt architecture (source ) 

## 3.1.2 Master

short declaration

Master provides a port to minions where minions can bind and watch for commands.

## 3.1.3 Minion

short declaration

All minions have unique id

Minion listens Master port and waits for events.

## 3.1.4 Secrets aka Pillars

short declaration

## 3.1.5 Top File

Usually infrastructure is made up of groups of machines, and each machine in the group is performing a role similar to others. 

File which contains mappings between role and machine is called top file.

Minion which ID or other feature, like grains, is matching top file configuration will apply state(s) that are defined in top file.

## 3.2 States created in ELK-stack project

Our Salt states are on GitHub
[Salt states](https://github.com/niinavi/Jarjestelmaprojekti/tree/master/srv/salt)

We just describe them in next chapters briefly because code itself should be self declarative.

### 3.2.1 Installation on Master server

Master server works in our setup as centralized log storage, where logs are stored and analyzed. Logstash, Elasticsearch and Kibana should be installed on master server.

Installing dependencies
- Only dependency is with Java 
- state: java

To make installation easy we first created Salt state to configure repository to get ELK-stack installations.
- state: elk-pkg

After creating preliminary states we created states to install ELK-stack
- States: elastic, logstash, kibana

Nginx is used as proxy to Kibana and it is installed using nginx-state
- state: nginx

Firewall rules for master server
- state: firewall

### 3.2.2 Installation on Minions

Minion servers will harvest and send logs to centralized log repository. To do that FileBeat is needed. We have also small test Web program which is using database. We use it to create logs in minions. 

Test program is coded with PHP, it runs on Apache and uses MariaDB. It also secures that full LAMP stack is working in minions. It is easy to test with it. Apache state also implements Apche virtual host name for testing purposes. 

Salt state to configure repository to get ELK-stack installations.
- state: elk-pkg

FileBeat installation
- state: filebeat

Apache and test Web application installation:
- state: apache 

MariaDB installtion
- state: mariadb

### 3.2.3 top.sls

Top.sls contains two roles, master and elk. Those are used to control what is installed to master server and what to minions.

### 3.2.4 Pillars

Pillar are used to store secrets. In our case installation script master.sh writes Kibana user password and Master IP to secrets.

Pillars are stored to /srv/pillar directory
- server.sls
- filebeat.sls

## 3.3 Bookstore test application to create logs  <a name="Testisovellus"></a>

Test application is simple PHP program which uses MariaDB database.

Users can read, update, delete and insert new books to database.

URL on minions: localhost:80/php or juha.example.com/php

# 4. Automatic installation  <a name="installation"></a>

ELK-stack can be installed using automation. We created scripts to install Salt master and minion for those servers where needed. After Salt installation states can be applied to minions with Salt commands.

Master server should be only one server, but minion can be installed on many different servers. Logs are harvested from minions and collected to master server where is Logstash, Elasticsearch and Kibana installed.

Master should be installed first and minions after that. Master server IP-address is needed during installation.

## 4.1 Automatic installation scripts

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


## Conclusions  <a name="conclusions"></a>

# Sources

Sebenik, Craig & Hatch, Thomas 2015. Salt Essentials: Getting started with automation at scale. O.Reilly media.

The Top File. https://docs.saltstack.com/en/latest/ref/states/top.html

