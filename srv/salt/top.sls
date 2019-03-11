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
