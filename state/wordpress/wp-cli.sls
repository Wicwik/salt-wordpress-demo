download_wp_cli:
  file.managed:
    - name: /usr/local/bin/wp
    - source: {{ pillar.get('wordpress_cli_source') }}
    - source_hash: {{ pillar.get('wordpress_cli_hash') }}
    - user: {{ pillar.get('domain') }}
    - group: {{ pillar.get('domain') }}
    - mode: 740