{% set pw = pillar.get('pw') %}

apache2-utils:
  pkg.installed

nginx:
  pkg.installed

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
    - htpasswd_file: /etc/nginx/htpasswd.kibana
    - options: d
    - force: true

nginx_restart:
  service.running:
    - name: nginx
    - watch:
      - file: /etc/nginx/nginx.conf
      - file: /etc/nginx/sites-available/kibana
      - file: /etc/nginx/sites-enabled/kibana
