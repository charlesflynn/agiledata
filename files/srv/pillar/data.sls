base_dir: /home/vagrant/agiledata
software_dir: software
downloads_dir: downloads
data_dir: data
user: vagrant
group: vagrant
install:
-
    name: java
    source: salt://jdk-6u45-linux-x64.bin
    filetype: bin
    extract_dir: jdk1.6.0_45
    extract_cmd: sh 
    hash: md5=40c1a87563c5c6a90a0ed6994615befe
-
    name: pig
    source: http://mirrors.gigenet.com/apache/pig/pig-0.11.1/pig-0.11.1.tar.gz
    filetype: tar.gz
    extract_dir: pig-0.11.1
    extract_cmd: tar xfz
    hash: md5=1495338b54be6961106a8a5248024945
