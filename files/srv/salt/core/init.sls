packages:
  pkg.installed:
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
    {% if grains['os'] == 'Debian' or grains['os'] == 'Ubuntu'%}
      - build-essential
      - python-dev
      - libsnappy-dev
      - ack-grep
      - netcat
      - vim
    {% elif grains['os'] == 'RedHat' or grains['os'] == 'Fedora' or grains['os'] == 'CentOS'%}
      - gcc
      - gcc-c++
      - kernel-devel
      - python-devel
      - snappy-devel
      - ack
      - nmap-ncat
      - vim-enhanced
    {% endif %}
