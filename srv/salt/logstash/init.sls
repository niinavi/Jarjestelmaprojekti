include:
  - java

logstash:
  pkg:
    - installed
    - version: '1:6.6.0-1'
    - require:
      - sls: java

/etc/logstash/conf.d/systems.conf:
  file.managed:
    - source: salt://logstash/systems.conf  

logstash.user:
  user.present:
    - name: logstash
    - groups: 
      - adm

logstash_service:
  service.running:
    - name: logstash
    - watch:
      - file: /etc/logstash/conf.d/systems.conf
