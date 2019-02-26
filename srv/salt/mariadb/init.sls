mariadb-server:
  pkg.installed
     
mariadb-client:
  pkg.installed

/tmp/createdb.sql:
  file.managed:
    - mode: 600
    - source: salt://mariadb/createdb.sql

run_create:
  cmd.run:
    - name: cat /tmp/createdb.sql | sudo mysql -u root
    - unless: "echo 'show databases'|sudo mysql -u root|grep '^books$'"
