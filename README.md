# agiledata

Builds a data science work environment for Russell Jurney's book [Agile Data Science](http://shop.oreilly.com/product/0636920025054.do).

## Prerequisites

You will need [Virtualbox](https://www.virtualbox.org/) and [Vagrant](http://www.vagrantup.com/) installed and working. If you are using a version of Vagrant older than 1.3.0, you will also need [Salty Vagrant](https://github.com/saltstack/salty-vagrant). Salty Vagrant requires Ruby development libraries (ruby-dev on Ubuntu/Debian or ruby-devel on RHEL/Fedora/Centos).

## Installation

1. Clone this repo and edit the `Vagrantfile` to customize your VM to taste.
2. Edit  `pillar/data.sls` and change `accept_oracle_download_terms` to `true`.
3. Run `vagrant up`

See the [Installation notes](#installation-notes) section below for comments on Java versions, operating systems, and details on a misleading error message you may receive.

The method for agreeing to the Oracle terms and downloading Java is based on the Chef [Java Cookbook](https://github.com/opscode-cookbooks/java).

### Initial run versus subsequent runs

During the intial run the components are downloaded, installed, and in some cases built. During subsequent runs only package/git updates (if any) are applied. On my machine with two CPUs assigned to the VM the initial run takes 21 minutes and subsequent runs take 1.5 minutes.

### Components

The VM environment includes the following major components:

- [Apache Pig](http://pig.apache.org/)
- [MongoDB](http://www.mongodb.org/)
- [MongoDB Hadoop Adapter](https://github.com/mongodb/mongo-hadoop)
- [Elasticsearch](http://www.elasticsearch.org/)
- [NumPy](http://www.numpy.org/)
- [SciPy](http://www.scipy.org/)
- [Flask](http://flask.pocoo.org/)
- [Oracle JDK 6u45](http://www.oracle.com/technetwork/java/javase/downloads/java-archive-downloads-javase6-419409.html#jdk-6u45-oth-JPR)

Please be aware that Oracle JDK 6u45 is known to contain several security vulnerabilities so be careful if you access the internet from the virtual machine. See the [Java versions](#java-versions) section below for further comments on choosing a different version.

Also included are many libraries, dependencies, and build tools. For a more complete list see [data.sls](https://github.com/charlesflynn/agiledata/blob/master/pillar/data.sls) in this repo, and Russell Jurney's [requirements.txt](https://github.com/rjurney/Agile_Data_Code/blob/master/requirements.txt).

## Usage

The book [Agile Data Science](http://shop.oreilly.com/product/0636920025054.do) contains instructions for the tools. This section documents small differences between the book and this environment.

### Directory layout

The default base directory is `/home/vagrant/agiledata`, which contains the following:
- `book-code`: a clone of the [Agile_Data_Code](https://github.com/rjurney/Agile_Data_Code) repo.
- `downloads`: tarfiles downloaded during installation.
- `env.sh`: source this script to set `JAVA_HOME` and add all tool binaries to your `PATH`.
- `linkjars.sh`: see the [Registering jarfiles in pig](#registering-jarfiles-in-pig) section below.
- `software`: tools and libraries are installed in this directory.
- `venv`: the python [virtualenv](http://www.virtualenv.org/) used in the book.

### Registering jarfiles in pig

The installation process creates and runs the script `linkjars.sh`. This script finds all jarfiles in the `software` directory and creates symlinks to them in `software/lib`. The symlinks make it easier to register jarfiles in pig scripts. For example, to register MongoDB jars in your pig script, you can use

    REGISTER /home/vagrant/agiledata/software/lib/mongo*.jar

rather than

    REGISTER /home/vagrant/agiledata/software/mongo-hadoop/flume/target/mongo-flume-1.1.0-SNAPSHOT.jar
    REGISTER /home/vagrant/agiledata/software/mongo-hadoop/target/mongo-hadoop-1.1.0-SNAPSHOT.jar
    REGISTER /home/vagrant/agiledata/software/mongo-hadoop/core/target/mongo-hadoop-core-1.1.0-SNAPSHOT.jar
    REGISTER /home/vagrant/agiledata/software/mongo-hadoop/pig/target/mongo-hadoop-pig-1.1.0-SNAPSHOT.jar
    REGISTER /home/vagrant/agiledata/software/software/lib/mongo-java-driver-2.11.1.jar

The `linkjars.sh` script is run during installation and each time the VM is rebooted. It is unlikely you will need to run it manually, but the script is provided just in case. Please note that the following jarfiles are actual files rather than symlinks, and will not be affected by running the script:

- `mongo-java-driver-2.11.1.jar`
- `avro-1.7.4.jar`
- `json-simple-1.1.1.jar`

## Installation notes

### Java versions

Many factors can influence your choice of Java version. Recommending a specific Java version is a dubious proposition, like providing health advice to strangers.

This project conservatively uses Oracle JDK 1.6, the version specified in Pig's [Getting Started](http://pig.apache.org/docs/r0.12.0/start.html#req) doc and historically used by enterprise Hadoop installations.

However, you do have other options:

- Pig has been [compatible with 1.7](https://issues.apache.org/jira/browse/PIG-2908) for a while
- [CDH4](http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH4/latest/CDH4-Requirements-and-Supported-Versions/cdhrsv_topic_3.html) works with 1.7
- [MapR](http://doc.mapr.com/display/MapR/Preparing+Each+Node#PreparingEachNode-java) and [Hortonworks](http://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.0.9.0/bk_installing_manually_book/content/rpm-chap1-2.html#rpm-chap1-2-5) work with 1.7 and will even work with OpenJDK

You may need to consult your organization, your sysadmin, your vendor, and/or your conscience before making this decision.

### Supported operating systems

This environment should work on any system that can run Virtualbox and Vagrant. If you experience problems installing on Windows related to changing file permissions (look for `Failed to change mode to 755`) in the output from the installation process you could try to delete line 13 in [oracle_java.sls](https://github.com/charlesflynn/agiledata/blob/master/salt/agiledata/oracle_java.sls#L13) related to

```
        - mode: 755
```

Windows does not have the same concept of file permissions as Unix-like and POSIX-compliant operating systems.

The default VM (configured in the `Vagrantfile`) is Ubuntu Precise x64. I have also tested with Fedora 18. The environment may work using other Redhat- or Debian-based distros as well.

### Misleading error message

Salt 0.15.x is affected by issue [saltstack/salt#4904](https://github.com/saltstack/salt/issues/4904), causing it to exit with code 2 rather than code 0 on successful run. Vagrant interprets this code as an error, and displays the following message:

    The following SSH command responded with a non-zero exit status.
    Vagrant assumes that this means the command failed!

    salt-call state.highstate -l debug

True errors in building the agiledata environment are much uglier than this. However, if you'd like to verify the installation, ssh into the VM with `vagrant ssh` and then run `sudo salt-call state.highstate -l debug`. This is a subsequent run, so it should take only a minute or two to complete. Since you are running the state directly rather than through Vagrant, you should see a true return code on success.
