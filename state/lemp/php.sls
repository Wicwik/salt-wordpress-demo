php_ondrej:
  pkgrepo.managed:
    - ppa: ondrej/php

php_versions:
  pkg.installed:
    - pkgs:
      - {{ pillar.get('php_version') }}
      - {{ pillar.get('php_version') }}-fpm
    - require:
      - pkgrepo: php_ondrej

php_packages:
  pkg.installed:
    - pkgs:
    {% for php_package in pillar.get('php_package', {}) %}
      - {{ php_package }}
    {% endfor %}
    - require:
      - pkgrepo: php_ondrej

/etc/php/{{ pillar.get('php_version') }}/fpm/pool.d/{{ pillar.get('domain') }}.conf:
  file.managed:
    - source: salt://lemp/files/etc/php/{{ pillar.get('php_version') }}/fpm/pool.d/domain.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - defaults:
        domain: {{ pillar.get('domain') }}
        php_version: {{ pillar.get('php_version') }}
    - watch_in:
      - service: php{{ pillar.get('php_version') }}-fpm
    - require:
      - pkg: php_versions
      - service: pillar.get('php_version')-fpm

pillar.get('php_version')-fpm:
  service.running:
    - enable: True
    - require:
      - pkg: php_versions


