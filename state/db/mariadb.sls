debconf_packages:
  pkg.installed:
    - pkgs:
      - debconf
      - debconf-utils

mariadb_10_3_debconf:
  debconf.set:
    - name: mysql-community-server
    - data: 
        'mysql-server/root_password': {'type': 'password', 'value': '{{ db_root_pass }}'}
        'mysql-server/root_password_again': {'type': 'password', 'value': '{{ db_root_pass }}'}
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
      - password={{ db_root_pass }}
      - default-character-set=utf8

/root/.mysqlpass:
  file.managed:
    - contents: {{ db_root_pass }}
    - user: root
    - group: root
    - mode: 0600

mariadb:
  service.running:
    - enable: True
    - require:
      - pkg: mariadb_10_3_packages




