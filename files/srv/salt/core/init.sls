core-pkgs:
  pkg.installed:
    - pkgs:
    {% if grains['os'] == 'Debian' or grains['os'] == 'Ubuntu'%}
      - build-essential
      - python-dev
      - libsnappy-dev
    {% elif grains['os'] == 'RedHat' or grains['os'] == 'Fedora' or grains['os'] == 'CentOS'%}
      - gcc
      - gcc-c++
      - kernel-devel
      - python-devel
      - snappy-devel
    {% endif %}
      - python-virtualenv

base-dir:
  file.directory:
    - name: {{ pillar['base_dir'] }}
    - user: {{ pillar['user'] }}
    - group: {{ pillar['group'] }}
    - file_mode: 744
    - dir_mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
      - mode

venv:
  virtualenv.manage:
    - name: {{ pillar['base_dir'] }}/venv
    - requirements: salt://core/requirements.txt
    - no_site_packages: True
    - distribute: True
    - python: python2.7
    - require:
      - pkg: core-pkgs
      - file: base-dir

java-install:
  file.managed:
    - name: {{ pillar['base_dir'] }}/install/{{ pillar['java_file'] }}
    - source: salt://core/{{ pillar['java_file'] }}
    - replace: False
    - makedirs: True
  cmd.wait:
    - cwd: {{ pillar['base_dir'] }}/install
    - name: sh {{ pillar['java_file'] }}
    - watch:
      - file: java-install

java-link:
  file.symlink:
    - name: {{ pillar['base_dir'] }}/java
    - target: {{ pillar['base_dir'] }}/install/{{ pillar['java_dir'] }}

#java-dir:
  #file.directory:
    #- name: {{ pillar['base_dir'] }}/{{ pillar['java_dir'] }}
    #- require:
      #- file: base-dir

#configure-ruby:
  #cmd:
    #- cwd: /tmp/ruby-1.9.2-p320
    #- names:
      #- ./configure
      #- make
      #- make install
    #- run
    #- require:
      #- cmd: extract-ruby
