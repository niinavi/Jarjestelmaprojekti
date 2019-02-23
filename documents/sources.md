## Elasticsearch

## Logstash

## Kibana

## SaltStack

- [State files syntax highlighting for different text editors](https://salt.tips/text-editor-plugins-for-salt-states-and-yaml-jinja/)

[Digital Ocean NGINX salt installation](https://www.digitalocean.com/community/tutorials/saltstack-infrastructure-creating-salt-states-for-nginx-web-servers)

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

