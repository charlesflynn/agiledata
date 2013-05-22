{% set downloads_dir = '{0}/downloads'.format(pillar.base_dir) %}
{% set software_dir = '{0}/software'.format(pillar.base_dir) %}
{% set data_dir = '{0}/data'.format(pillar.base_dir) %}
{% set lib_dir = '{0}/lib'.format(pillar.base_dir) %}

directories:
  file.directory:
    - names: 
      - {{ pillar.base_dir }}
      - {{ software_dir }}
      - {{ downloads_dir }}
      - {{ data_dir }}
      - {{ lib_dir }}
    - user: {{ pillar.user }}
    - group: {{ pillar.group }}
    - file_mode: 744
    - dir_mode: 755
    - makedirs: True

env.sh:
  file.managed:
    - name: {{ pillar.base_dir }}/env.sh
    - source: salt://agiledata/env.sh
    - user: {{ pillar.user }}
    - mode: 755
    - require:
      - file: directories

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


{% for item in pillar.lib %}
{% set install_file = lib_dir + '/' + item.source.rpartition('/')[2] %}
{{ item.name }}-file:
  file.managed:
    - name: {{ install_file }}
    - user: {{ pillar.user }}
    - source: {{ item.source }}
    - source_hash: {{ item.hash }}
    - require:
      - file: directories
{% endfor %}


{% for item in pillar.software %}

{% set install_file = downloads_dir + '/' + item.source.rpartition('/')[2] %}
{% set unpack = 'tar xfa' %}

{% if item.name ==  'java' %}
{% from 'agiledata/oracle_java.sls' import get_java with context %}
{{ get_java(install_file) }}
{% set unpack = 'sh' %}
{% endif %}

{{ item.name }}-file:
  file.managed:
    - name: {{ install_file }}
    - user: {{ pillar.user }}
    - source: {{ item.source }}
    - source_hash: {{ item.hash }}
    - require:
      - file: directories

{{ item.name }}-install:
  cmd.wait:
    - name: {{ unpack }} {{ install_file }}; ln -s {{ item.target }} {{ item.name}}
    - user: {{ pillar.user }}
    - cwd: {{ software_dir }}
    - unless: file {{ software_dir }}/{{ item.target }}
    - watch:
      - file: {{ item.name }}-file
{% endfor %}


{% for item in pillar.git %}
{{ item.target }}-git:
  git.latest:
    - name: {{ item.name }}
    - target: {{ software_dir }}/{{ item.target }}
    - runas: {{ pillar.user }}
    - require:
      - pkg: packages
      - file: directories
  cmd.run:
    - name: source {{ pillar.base_dir }}/env.sh; {{ item.cmd }}
    - user: {{ pillar.user }}
    - cwd: {{ software_dir }}/{{ item.target }}
    - watch:
      - git: {{ item.target }}-git
    - require:
      - file: env.sh
      - cmd: java-install
      - cmd: maven-install
{% endfor %}
