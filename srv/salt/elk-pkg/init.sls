base:
  pkgrepo.managed:
    - humanname: Elastic
    - name: deb https://artifacts.elastic.co/packages/6.x/apt stable main
    - dist: stable
    - file: /etc/apt/sources.list.d/elastic.list
    - gpgcheck: 1
    - key_url: https://artifacts.elastic.co/GPG-KEY-elasticsearch
    - require_in:
      - elastic
      - kibana
      - logstash
      - filebeat
