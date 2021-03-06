mariadb_10_6_packages:
  pkg.installed:
    - pkgs:
      - mariadb-client-10.6
      - libmysqlclient-dev
      - python3-mysqldb
    - refresh: True

download_wordpress:
 cmd.run:
  - cwd: /data/web/{{ pillar.get('domain') }}/web/
  - name: '/usr/local/bin/wp core download --path="/data/web/{{ pillar.get('domain') }}/web/"'
  - runas: {{ pillar.get('domain') }}
  - unless: test -f /data/web/{{ pillar.get('domain') }}/web/wp-config.php
  - require:
    - file: download_wp_cli

configure_wordpress:
 cmd.run:
  - name: '/usr/local/bin/wp core config --dbname="{{ pillar.get('database') }}" --dbuser="{{ pillar.get('dbuser') }}" --dbpass="{{ pillar.get('dbpass') }}" --dbhost="{{ pillar.get('server_db_ip') }}" --path="/data/web/{{ pillar.get('domain') }}/web/"'
  - cwd: /data/web/{{ pillar.get('domain') }}/web/
  - runas: {{ pillar.get('domain') }}
  - require:
    - file: download_wp_cli
    - pkg: mariadb_10_6_packages

install_wordpress:
 cmd.run:
  - cwd: /data/web/{{ pillar.get('domain') }}/web/
  - name: '/usr/local/bin/wp core install --url="http://{{ pillar.get('domain') }}" --title="{{ pillar.get('title') }}" --admin_user="{{ pillar.get('username') }}" --admin_password="{{ pillar.get('password') }}" --admin_email="{{ pillar.get('email') }}" --path="/data/web/{{ pillar.get('domain') }}/web/"'
  - runas: {{ pillar.get('domain') }}
  - unless: /usr/local/bin/wp core is-installed --path="/data/web/{{ pillar.get('domain') }}/web/"
