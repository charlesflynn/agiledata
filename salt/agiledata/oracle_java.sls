{% macro get_java(software_dir) %}
{% set install_file = '/srv/salt/agiledata/jdk-6u45-linux-x64.bin' %}
java-download:
  cmd.run:
    - name: curl -L --cookie "oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-linux-x64.bin -o {{ install_file }}
    - unless: file {{ install_file }}
    - require:
      - file: directories

java-file:
  file.managed:
    - name: {{ install_file }}
    - mode: 755
    - require:
      - cmd: java-download

java-install:
  cmd.run:
    - name: sh {{ install_file }}; ln -s jdk1.6.0_45 java
    - cwd: {{ software_dir }}
    - unless: file {{ software_dir }}/jdk1.6.0_45
    - require:
      - file: java-file

{% endmacro %}
