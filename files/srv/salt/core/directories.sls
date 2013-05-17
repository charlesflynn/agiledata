base-dir:
  file.directory:
    - names: 
      - {{ pillar.base_dir }}
      - {{ pillar.base_dir }}/{{ pillar.software_dir }}
      - {{ pillar.base_dir }}/{{ pillar.downloads_dir }}
      - {{ pillar.base_dir }}/{{ pillar.data_dir }}
    - user: {{ pillar.user }}
    - group: {{ pillar.group }}
    - file_mode: 744
    - dir_mode: 755
    - makedirs: True
    #- recurse:
      #- user
      #- group
      #- mode
