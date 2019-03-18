apache2install:
  pkg.installed:
    - pkgs:
        - apache2
        - libapache2-mod-php
        - php-mysql

/etc/hosts:
  file.managed:
    - source: salt://apache/hosts

/var/www/html/index.html:
  file.managed:
    - source: salt://apache/index.html

/var/log/apache2/access2.log:
  file.managed:
    - source: salt://apache/access2.log

/etc/apache2/sites-available/juha.example.com.conf:
  file.managed:
    - source: salt://apache/juha.example.com.conf

/etc/apache2/mods-enabled/userdir.conf:
  file.symlink:
    - target: ../mods-available/userdir.conf

/etc/apache2/mods-enabled/userdir.load:
  file.symlink:
    - target: ../mods-available/userdir.load

a2ensite juha.example.com.conf:
  cmd.run

/etc/apache2/mods-enabled/php7.2.conf:
  file.managed:
    - source: salt://apache/php7.2.conf

user_xubuntu:
  user.present:
    - name: xubuntu
    - shell: /bin/bash
    - fullname: Juha Immonen test user

/home/xubuntu/public_html:
  file.directory:
    - user: xubuntu
    - group: xubuntu
    - mode: 775

/home/xubuntu/public_html/php:
  file.recurse:
    - source: salt://apache/php
    - include_empty: True
    - user: xubuntu
    - group: xubuntu

apache2restart:
  service.running:
    - name: apache2
    - watch:
      - file: /etc/apache2/sites-available/juha.example.com.conf
      - file: /etc/apache2/mods-enabled/userdir.conf
      - file: /etc/apache2/mods-enabled/userdir.load
      - file: /etc/apache2/mods-enabled/php7.2.conf



