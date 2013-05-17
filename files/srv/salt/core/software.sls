{% set downloads_dir = "%s/%s" % (pillar.base_dir, pillar.downloads_dir) %}
{% set software_dir = "%s/%s" % (pillar.base_dir, pillar.software_dir) %}

{% for item in pillar.install %}

{% set install_dir = "%s/%s" % (software_dir, item.extract_dir) %}
{% set install_link = "%s/%s" % (software_dir, item.name) %}
{% set install_file = "%s/%s.%s" % (downloads_dir, item.extract_dir, item.filetype) %}


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
    - name: {{ item.extract_cmd }} {{ install_file }}; ln -s {{ item.extract_dir }} {{ item.name}}
    - user: {{ pillar.user }}
    - cwd: {{ software_dir }}
    - unless: file {{ install_dir }}

{% endfor %}
