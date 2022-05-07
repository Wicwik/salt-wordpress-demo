haproxy:
  pkg:
    - installed
  service.running:
    - watch:
      - pkg: haproxy
      - file: /etc/haproxy/haproxy.cfg

/etc/haproxy/haproxy.cfg:
  file.managed:
    - source: salt://proxy/files/etc/haproxy/haproxy.cfg
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - defaults:
        domain: {{ pillar.get('domain') }}
        proxy_ip: {{ pillar.get('server_db_ip') }}
        web_ip: {{ pillar.get('server_web_ip') }}
    - require:
      - pkg: haproxy