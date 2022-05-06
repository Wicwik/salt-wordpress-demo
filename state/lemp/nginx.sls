{% for folder in ['web', 'sub', 'logs'] %}
nginx_folder_structure_{{ pillar.get('domain') }}/{{ folder }}:
  file.directory:
    - name: /data/web/{{ pillar.get('domain') }}/{{ folder }}
    - user: {{ pillar.get('domain') }}
    - group: {{ pillar.get('domain') }}
    - dir_mode: 775
    - makedirs: True
{% endfor %}

nginx_packages:
  pkg.installed:
    - pkgs:
      - nginx

/etc/nginx/sites-available/{{ pillar.get('domain') }}.conf:
  file.managed:
    - source: salt://lemp/files/etc/nginx/sites-available/domain.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - defaults:
        domain: {{ pillar.get('domain') }}
    - watch_in:
      - service: nginx

nginx_symlink_enable_{{ domain }}:
  file.symlink:
      - name: /etc/nginx/site-available/{{ pillar.get('domain') }}.conf
      - target: /etc/nginx/site-enabled/{{ pillar.get('domain') }}.conf
      - require:
        - pkg: nginx_packages
      - watch_in:
        - service: nginx


nginx:
  service.running:
    - enable: True
    - require:
      - pkg: nginx_packages


