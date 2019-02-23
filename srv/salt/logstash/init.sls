include:
  - java

logstash:
  pkg:
    - installed
    - version: '1:6.6.0-1'
    - require:
      - sls: java
