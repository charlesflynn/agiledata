accept_oracle_download_terms: true
base_dir: /home/vagrant/agiledata
user: vagrant
group: vagrant

lib:
-
  name: avro
  source: http://apache.mirrors.hoobly.com/avro/stable/java/avro-1.7.4.jar
  hash: sha1=11d1ef0cbbf50ed5c9438ccd8ee69f75f083694d
-
  name: json-simple
  source: https://json-simple.googlecode.com/files/json-simple-1.1.1.jar
  hash: sha1=5d6f9b6a9ddca2a28c0216cc44efb2e20d9c23b5
-
  name: mongo-driver
  source: http://central.maven.org/maven2/org/mongodb/mongo-java-driver/2.11.1/mongo-java-driver-2.11.1.jar
  hash: sha1=27b3fb1a03e44abb344c66b920ad89538cae685a

software:
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
-
  name: maven
  source: http://mirror.sdunix.com/apache/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz
  target: apache-maven-3.0.5
  cmd: tar xfa
  hash: md5=94c51f0dd139b4b8549204d0605a5859

git:
-
  name: https://github.com/mongodb/mongo-hadoop.git
  target: mongo-hadoop
  cmd: ./sbt update; ./sbt package
-
  name: https://github.com/infochimps-labs/wonderdog.git
  target: wonderdog
  cmd: mvn install
-
  name: https://github.com/Ganglion/varaha.git
  target: varaha
  cmd: mvn install
