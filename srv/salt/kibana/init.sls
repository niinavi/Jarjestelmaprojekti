include:
  - java

kibana:
  pkg:
    - installed
    - version: '6.6.0'
    - require:
      - sls: java

/etc/kibana/kibana.yml:
  file.managed:
    - source: salt://kibana/kibana.yml

kibana_service:
  service.running:
    - name: kibana
    - watch:
      - file: /etc/kibana/kibana.yml
