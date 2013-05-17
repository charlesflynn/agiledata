venv:
  virtualenv.manage:
    - name: {{ pillar.base_dir }}/venv
    - runas: {{ pillar.user }}
    - requirements: salt://core/requirements.txt
    - no_site_packages: True
    - distribute: True
    - python: python2.7
    - require:
      - pkg: packages
      - file: base-dir
