accept_oracle_download_terms: false
base_dir: /home/vagrant/agiledata
user: vagrant
group: vagrant

bin:
-
  name: ack
  source: http://beyondgrep.com/ack-2.12-single-file
  hash: sha1=667b5f2dd83143848a5bfa47f7ba848cbe556e93
-
  name: jq
  source: http://stedolan.github.io/jq/download/linux64/jq
  hash: sha1=e820e9e91c9cce6154f52949a3b2a451c4de8af4

lib:
-
  name: avro
  source: http://apache.mirrors.pair.com/avro/avro-1.7.7/java/avro-1.7.7.jar
  hash: sha1=c2fb3e7fca907ac6485d6e4b8b87c29cdcdd3333
-
  name: json-simple
  source: https://json-simple.googlecode.com/files/json-simple-1.1.1.jar
  hash: sha1=5d6f9b6a9ddca2a28c0216cc44efb2e20d9c23b5
-
  name: mongo-driver
  source: http://central.maven.org/maven2/org/mongodb/mongo-java-driver/2.12.3/mongo-java-driver-2.12.3.jar
  hash: sha1=12b7358a7740af71a4a52349d014d526a7a26a65

software:
-
  name: pig
  source: http://archive.apache.org/dist/pig/pig-0.11.1/pig-0.11.1.tar.gz
  target: pig-0.11.1
  cmd: tar xfa
  hash: md5=1495338b54be6961106a8a5248024945
-
  name: mongodb
  source: http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.6.3.tgz
  target: mongodb-linux-x86_64-2.6.3
  cmd: tar xfa
  hash: md5=9b3db9b6d889e6bc0d6e3bfe4316a85a
-
  name: elasticsearch
  source: https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.13.tar.gz
  target: elasticsearch-0.90.13
  cmd: tar xfa
  hash: sha1=bc4f805f052fbefbd2b4c392b108e62f08bf8380
-
  name: maven
  source: http://apache.mirrors.pair.com/maven/maven-3/3.2.2/binaries/apache-maven-3.2.2-bin.tar.gz
  target: apache-maven-3.2.2
  cmd: tar xfa
  hash: md5=87e5cc81bc4ab9b83986b3e77e6b3095

git:
-
  name: https://github.com/mongodb/mongo-hadoop.git
  target: mongo-hadoop
  cmd: ./gradlew jar
-
  name: https://github.com/infochimps-labs/wonderdog.git
  target: wonderdog
  cmd: mvn install
-
  name: https://github.com/Ganglion/varaha.git
  target: varaha
  cmd: mvn install
