{% set logstash_ip = pillar.get('logstash_ip', 'localhost') %}

filebeat:
  pkg:
    - installed
    - version: '6.6.0'

/etc/filebeat/filebeat.yml:
  file.managed:
    - source: salt://filebeat/filebeat.yml
    - template: jinja
    - context:
      logstash_ip: {{ logstash_ip  }}

filebeat_service:
  service.running:
    - name: filebeat
    - watch:
      - file: /etc/filebeat/filebeat.yml
