filebeat:
  pkg:
    - installed
    - version: '6.6.0'

/etc/filebeat/filebeat.yml:
  file.managed:
    - source: salt://filebeat/filebeat.yml

filebeat_service:
  service.running:
    - name: filebeat
    - watch:
      - file: /etc/filebeat/filebeat.yml
