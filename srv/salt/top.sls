base:
  'elk':
    - elk-pkg
    - apache
    - mariadb
    - filebeat
    
  'master':
    - java
    - elk-pkg
    - elastic
    - kibana
    - nginx
    - logstash
