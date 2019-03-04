 ufw:
   pkg.installed

 /etc/ufw/user.rules:
  file:
    - managed
    - source: salt://firewall/user.conf
    - require:
      - pkg: ufw

 /etc/ufw/user6.rules:
  file:
    - managed
    - source: salt://firewall/user6.conf
    - require:
      - pkg: ufw

 ufw-enable:
   cmd.run:
     - name: 'ufw --force enable'
     - require:
       - pkg: ufw
