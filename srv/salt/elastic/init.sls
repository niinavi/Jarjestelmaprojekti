include:
  - java

elasticsearch:
  pkg:
    - installed
    - version: '6.6.0'
    - require:
      - sls: java
