{% set downloads_dir = '{0}/downloads'.format(pillar.base_dir) %}
{% set software_dir = '{0}/software'.format(pillar.base_dir) %}
{% set data_dir = '{0}/data'.format(pillar.base_dir) %}

directories:
  file.directory:
    - names: 
      - {{ pillar.base_dir }}
      - {{ software_dir }}
      - {{ downloads_dir }}
      - {{ data_dir }}
    - user: {{ pillar.user }}
    - group: {{ pillar.group }}
    - file_mode: 744
    - dir_mode: 755
    - makedirs: True

tmux-conf:
  file.managed:
    - name: /home/{{ pillar.user }}/.tmux.conf
    - source: salt://agiledata/tmux.conf
    - user: {{ pillar.user }}

venv:
  virtualenv.manage:
    - name: {{ pillar.base_dir }}/venv
    - runas: {{ pillar.user }}
    - requirements: salt://agiledata/requirements.txt
    - no_site_packages: True
    - distribute: True
    - python: python2.7
    - require:
      - pkg: packages
      - file: directories


{% for item in pillar.software %}

{% set install_file = downloads_dir + '/' + item.source.rpartition('/')[2] %}

{{ item.name }}-file:
  file.managed:
    - name: {{ install_file }}
    - user: {{ pillar.user }}
    - makedirs: True
    - source: {{ item.source }}
{% if 'hash' in item %}
    - source_hash: {{ item.hash }}
{% endif %}

{{ item.name }}-install:
  cmd.run:
    - name: {{ item.cmd }} {{ install_file }}; ln -s {{ item.target }} {{ item.name}}
    - user: {{ pillar.user }}
    - cwd: {{ software_dir }}
    - unless: file {{ software_dir }}/{{ item.target }}
{% endfor %}
