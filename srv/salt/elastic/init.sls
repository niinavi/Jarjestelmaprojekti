include:
  - java

elasticsearch:
  pkg:
    - installed
    - version: '6.6.0'
    - require:
      - sls: java

/etc/elasticsearch/elasticsearch.yml:
  file.managed:
    - source: salt://elastic/elasticsearch.yml

elasticsearch_service:
  service.running:
    - name: elasticsearch
    - watch:
      - file: /etc/elasticsearch/elasticsearch.yml
