## SaltStack and Nginx

I installed master and minion on VirtualBox Ubuntu 18.04 LTS.

I edited file /etc/salt/minion file on minion.
```
$ master: mastersIP
```

I run the command to start minion
```
$ salt-minion -d
```

I listed all salt-keys (-L) and accepted them (-A).
```
$ salt-key -L
$ salt-key -A
```

I tested with test.ping on master
```
$ salt '*' test.ping
niina:
		True
```

## Creating saltstate for Nginx

I created a directory /etc/salt/nginx and a state file inside the nginx directory.
```
$ sudo mkdir /srv/salt/nginx
$ sudo nano /srv/salt/nginx/init.sls
```

I added text below into the state file.

```
nginx:
  pkg:
    - installed

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://nginx/files/etc/nginx/nginx.conf
    - user: root
    - group: root
    - mode: 640

/etc/nginx/sites-available/default:
  file.managed:
    - source: salt://nginx/files/etc/nginx/sites-available/default
    - user: root
    - group: root
    - mode: 640

/etc/nginx/sites-enabled/default:
  file.symlink:
    - target: /etc/nginx/sites-available/default
    - require:
      - file: /etc/nginx/sites-available/default

/usr/share/nginx/html/index.html:
  file.managed:
    - source: salt://nginx/files/usr/share/nginx/html/index.html
    - user: root
    - group: root
    - mode: 644

```


I needed to install nginx to the slave so I would be able to copy the needed files to the master. To be able to do that, I needed to enable file_recv in /etc/salt/master -file.
```
file_recv: True
```

I used cp.push command to make minion to push the files to master.

```
$ sudo salt minion-ID cp.push /etc/nginx/nginx.conf
$ sudo salt minion-ID cp.push /etc/nginx/sites-available/default
$ sudo salt minion-ID cp.push /usr/share/nginx/html/index.html
```

The files will be stored in /var/cache/salt/master/minions/minion_id/files. I needed to copy them to the right location.

```
$ sudo cp -r /var/cache/salt/master/minions/minion-ID/files /srv/salt/nginx
```

I removed nginx from minion. I did this from the minion and it is not convenient.
```
$ sudo apt-get purge nginx nginx-common
```

I applied the state to the minion.
```
$ sudo salt '*' state.apply nginx
```

I received error saying "Too many functions declared in state 'file' ".  
I fixed it: "mode:644" --> "mode: 644"

-------------------------------------
https://www.digitalocean.com/community/tutorials/saltstack-infrastructure-creating-salt-states-for-nginx-web-servers

http://terokarvinen.com/
