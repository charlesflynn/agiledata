{% set downloads_dir = '{0}/downloads'.format(pillar.base_dir) %}
{% set bin_dir = '{0}/bin'.format(pillar.base_dir) %}
{% set book_dir = '{0}/book-code'.format(pillar.base_dir) %}
{% set software_dir = '{0}/software'.format(pillar.base_dir) %}
{% set venv_dir = '{0}/venv'.format(pillar.base_dir) %}
{% set lib_dir = '{0}/lib'.format(software_dir) %}
{% set data_dir = '/data' %}
{% set mongo_dir = '{0}/db'.format(data_dir) %}

ackrc:
  file.managed:
    - name: /home/{{ pillar.user }}/.ackrc
    - source: salt://agiledata/ackrc
    - user: {{ pillar.user }}
    - mode: 755

directories:
  file.directory:
    - names: 
      - {{ pillar.base_dir }}
      - {{ downloads_dir }}
      - {{ bin_dir }}
      - {{ book_dir }}
      - {{ software_dir }}
      - {{ lib_dir }}
      - {{ data_dir }}
      - {{ mongo_dir }}
    - user: {{ pillar.user }}
    - group: {{ pillar.group }}
    - file_mode: 744
    - dir_mode: 755
    - recurse:
        - user
        - group
        - mode
    - makedirs: True
    - require:
      - pkg: packages

{% if pillar.accept_oracle_download_terms == true %}
{% from 'agiledata/oracle_java.sls' import get_java with context %}
{{ get_java(software_dir) }}
{% endif %}

book-code:
  git.latest:
    - name: https://github.com/rjurney/Agile_Data_Code.git
    - target: {{ book_dir }}
    - runas: {{ pillar.user }}
    - require:
      - file: directories

venv:
  virtualenv.manage:
    - name: {{ venv_dir }}
    - runas: {{ pillar.user }}
    - no_site_packages: True
    - distribute: True
    - python: python2.7
    - require:
      - file: directories

env.sh:
  file.managed:
    - name: {{ pillar.base_dir }}/env.sh
    - source: salt://agiledata/env.sh.jinja
    - template: jinja
    - defaults:
        bin_dir: {{ bin_dir }}
        software_dir: {{ software_dir }}
    - user: {{ pillar.user }}
    - mode: 755
    - require:
      - virtualenv: venv

numpy:
  pip.installed:
    - bin_env: {{ venv_dir }}
    - require:
      - pkg: packages
      - virtualenv: venv

scipy:
  pip.installed:
    - bin_env: {{ venv_dir }}
    - require:
      - pip: numpy

book-pip:
  pip.installed:
    - bin_env: {{ venv_dir }}
    - requirements: {{ book_dir }}/requirements.txt
    - order: last
    - require:
      - pip: scipy

link-jars:
  file.managed:
    - name: {{ pillar.base_dir }}/linkjars.sh
    - source: salt://agiledata/linkjars.sh.jinja
    - template: jinja
    - defaults:
        software_dir: {{ software_dir }}
        lib_dir: {{ lib_dir }}
    - user: {{ pillar.user }}
    - mode: 755
  cmd.run:
    - name: {{ pillar.base_dir }}/linkjars.sh
    - user: {{ pillar.user }}
    - order: last


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


{% for item in pillar.bin %}
{% set install_file = bin_dir + '/' + item.name %}
{{ item.name }}-file:
  file.managed:
    - name: {{ install_file }}
    - user: {{ pillar.user }}
    - mode: 755
    - source: {{ item.source }}
    - source_hash: {{ item.hash }}
    - require:
      - file: directories
{% endfor %}


{% for item in pillar.software %}

{% set install_file = downloads_dir + '/' + item.source.rpartition('/')[2] %}
{% set unpack = 'tar xfa' %}

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
