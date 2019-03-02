include:
  - java

logstash:
  pkg:
    - installed
    - version: '1:6.6.0-1'
    - require:
      - sls: java

/usr/share/logstash/test-pipeline.conf:
  file.managed:
    - source: salt://logstash/test-pipeline.conf  

logstash.user:
  user.present:
    - name: logstash
    - groups: 
      - adm

logstash_service:
  service.running:
    - name: logstash
    - watch:
      - file: /usr/share/logstash/test-pipeline.conf
