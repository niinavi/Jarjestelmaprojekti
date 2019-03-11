{% set pw = pillar.get('pw') %}

nginx:
  pkg:
    - installed
  service.running:
    - watch:
      - pkg: nginx
      - file: /etc/nginx/nginx.conf
      - file: /etc/nginx/sites-available/kibana

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://nginx/nginx.conf
    - user: root
    - group: root
    - mode: 640

/etc/nginx/sites-available/kibana:
  file.managed:
    - source: salt://nginx/sites-available/kibana

/etc/nginx/sites-enabled/kibana:
  file.symlink:
    - target: /etc/nginx/sites-available/kibana
    - require:
      - file: /etc/nginx/sites-available/kibana

nginx-default-available:
  file.absent:
    - name: /etc/nginx/sites-available/default
    - require:
      - pkg: nginx

nginx-default-enabled:
  file.absent:
    - name: /etc/nginx/sites-enabled/default
    - require:
      - pkg: nginx
niina:
  webutil.user_exists:
    - password: {{ pw }}
    - htpasswd_file: /etc/nginx/htpasswd
    - options: d
    - force: true
