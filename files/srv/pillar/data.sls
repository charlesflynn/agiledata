base_dir: /home/vagrant/agiledata
data_dir: data
user: vagrant
group: vagrant
software:
-
    name: java
    source: salt://jdk-6u45-linux-x64.bin
    target: jdk1.6.0_45
    cmd: sh 
    hash: md5=40c1a87563c5c6a90a0ed6994615befe
-
    name: pig
    source: http://mirrors.gigenet.com/apache/pig/pig-0.11.1/pig-0.11.1.tar.gz
    target: pig-0.11.1
    cmd: tar xfa
    hash: md5=1495338b54be6961106a8a5248024945
-
    name: mongodb
    source: http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.4.3.tgz
    target: mongodb-linux-x86_64-2.4.3
    cmd: tar xfa
    hash: md5=cdf9cb252e9635c4db1a309f4646aefa
-
    name: elasticsearch
    source: https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.0.tar.gz
    target: elasticsearch-0.90.0
    cmd: tar xfa
    hash: sha1=92b8c07b51cedda7c8148eceb23bbcb79bccf230
