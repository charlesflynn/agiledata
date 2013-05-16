core:
  pkg.installed:
    - pkgs:
    {% if grains['os'] == 'Debian' or grains['os'] == 'Ubuntu'%}
      - build-essential
      - python-dev
    {% elif grains['os'] == 'RedHat' or grains['os'] == 'Fedora' or grains['os'] == 'CentOS'%}
      - gcc
      - gcc-c++
      - kernel-devel
      - python-devel
    {% endif %}
      - python-virtualenv
