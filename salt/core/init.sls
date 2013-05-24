packages:
  pkg.latest:
    - pkgs:
      - ntp
      - net-tools
      - htop
      - lsof
      - tmux
      - curl
      - git
      - curl
      - python-virtualenv
    {% if grains['os'] == 'Debian' or grains['os'] == 'Ubuntu' %}
      - netcat
      - vim
      - build-essential
      - python-dev
      - libsnappy-dev
      - libatlas-base-dev
      - liblapack-dev
      - gfortran
    {% elif grains['os'] == 'RedHat' or grains['os'] == 'Fedora' or grains['os'] == 'CentOS' %}
      - nmap-ncat
      - vim-enhanced
      - gcc
      - gcc-c++
      - kernel-devel
      - python-devel
      - snappy-devel
      - atlas-devel
      - lapack-devel
      - gcc-gfortran
    {% endif %}
