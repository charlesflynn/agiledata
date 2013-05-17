packages:
  pkg.installed:
    - pkgs:
      - python-virtualenv
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
