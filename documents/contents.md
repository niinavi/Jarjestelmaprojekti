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

<details>
    
<summary>Purpose<a name="purpose"></a></summary>

</details>

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

Salt is a remote execution framework and configuration management system. Salt is build to solve problem, how to manage multiple servers whether it is 2 or 10 000 machines. Salt design is basic master - client architecture. One server is master and minions can be many. Master server controls minions.

Default configuration uses standard data format, yaml. Salt states are only text written in yaml format. That gives a great benefit, states can be versioned. It is also declarative model, states are not list of imperatice commands. Salt keeps minions in desired state after original installation. Desired state are at Salta state files.

In our project we used Salt to automatically install ELK-stack on wanted machines.

## 3.2 Architecture <a name="architecture2"></a>

Picture

## 3.3 Master

short declaration

## 3.4 Minion

short declaration

## 3.5 Secrets aka Pillars

short declaration

## States created in ELK-stack project

Our Salt states are on GitHub
[Salt states](https://github.com/niinavi/Jarjestelmaprojekti/tree/master/srv/salt)

We just describe them briefly here because code itself should be self declarative.

### Installation on Master server

Master server states

### Installation on Minions

Minion server states

# Automatic installation  <a name="installation"></a>

ELK-stack can be installed using automation. We created scripts to install Salt master and minion for those servers where needed. After Salt installation states can be applied to minions with Salt commands.

Master server should be only one server, but minion can be installed on many different servers. Logs are harvested from minions and collected to master server where is Logstash, Elasticsearch and Kibana installed.

Master should be installed first and minions after that. Master server IP-address is needed during installation.

## Automatic installation scripts usage

### Install Salt Master

During installation scripts asks input form user. Kibana user password should be given during installation.

```
wget https://raw.githubusercontent.com/niinavi/Jarjestelmaprojekti/master/srv/master.sh
chmod g+x master.sh
sudo ./master.sh
```

### Install Salt Minion

During installation scripts asks input form user. Master IP-addres and name of minion should be given.

```
wget https://raw.githubusercontent.com/niinavi/Jarjestelmaprojekti/master/srv/minion.sh
chmod g+x minion.sh
sudo ./minion.sh
```

### Accept Minion keys

Accept minion keys at Master.

```
sudo salt-key -A
```

### Run Salt states to minions

Salt minion is also installed to Master server. It will install Logstash, Elasticsearch and Kibana to master server.

```
sudo salt '*' state.highstate
```

Command runs all minions to desired state.

## Log analytics with Kibana  <a name="analytics"></a>
## Testisovellus  <a name="Testisovellus"></a>
## Conclusions  <a name="conclusions"></a>

