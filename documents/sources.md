## Elasticsearch

## Logstash

## Kibana

## SaltStack

## Web authentication

## FileBeat

## rsyslog

--------------------------------

<details>
<summary>Quick & easy installation of LogStash, ElasticSearch & Kibana on Ubuntu 18.04 LTS</summary>

Copy & paste the following into terminal:

```
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elkstack.list
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

sudo apt update && sudo apt -y install logstash elasticsearch kibana

```

</details>

