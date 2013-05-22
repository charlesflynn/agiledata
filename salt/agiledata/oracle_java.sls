{% macro get_java(install_file) %}
{% if pillar.accept_oracle_download_terms == true %}

java-download:
  cmd.run:
    - name: curl -L --cookie "oraclelicensejdk-6u45-oth-JPR=accept-securebackup-cookie;gpw_e24=http://edelivery.oracle.com" http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-linux-x64.bin -o {{ install_file }}
    - user: {{ pillar.user }}
    - unless: file {{ install_file }}
    - require:
      - file: directories

{% endif %}
{% endmacro %}
