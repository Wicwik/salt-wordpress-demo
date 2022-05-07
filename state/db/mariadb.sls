debconf_packages:
  pkg.installed:
    - pkgs:
      - debconf
      - debconf-utils

mariadb_10_3_debconf:
  debconf.set:
    - name: mysql-community-server
    - data: 
        'mysql-server/root_password': {'type': 'password', 'value': {{ pillar.get('db_root_pass') }}}
        'mysql-server/root_password_again': {'type': 'password', 'value': {{ pillar.get('db_root_pass') }}}
    - require:
      - pkg: debconf_packages

mariadb_10_3_packages:
  pkg.installed:
    - pkgs:
      - mariadb-common
      - mariadb-client-10.3
      - mariadb-server-10.3
      - libmysqlclient-dev
      - python3-mysqldb
    - refresh: True
    - require:
      - debconf: mariadb_10_3_debconf

apparmor:
  service.running:
    - reload: True

/etc/apparmor.d/disable/usr.sbin.mysqld:
  file.symlink:
    - target: /etc/apparmor.d/usr.sbin.mysqld
    - watch_in:
      - service: apparmor

/root/.my.cnf:
  file.managed:
    - user: root
    - group: root
    - contents:
      - '[client]'
      - host=localhost
      - user=root
      - password={{ pillar.get('db_root_pass') }}
      - default-character-set=utf8

/root/.mysqlpass:
  file.managed:
    - contents: {{ pillar.get('db_root_pass') }}
    - user: root
    - group: root
    - mode: 0600

mariadb:
  service.running:
    - enable: True
    - require:
      - pkg: mariadb_10_3_packages

wp_db:
  mysql_database.present:
    - name: {{ pillar.get(dbname) }}
    - connection_host: localhost
    - connection_user: root
    - connection_pass: {{ pillar.get('db_root_pass') }}
    - require:
      - service: mariadb

wp_user:
  mysql_user.present:
    - name: {{ pillar.get(dbuser) }}
    - password: {{ pillar.get(dbpass) }}
    - host: '%'
    - use:
      - mysql_database: wp_db


