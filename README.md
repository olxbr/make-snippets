# Make Snippets

A collection of Makefiles that helps in various tasks:

 - building docker images
 - deploying docker images
 - creating AWS CloudFormation stacks

## Architecture

Move along, nothing to see here.

## Application Checklist

Move along, nothing to see here.

## Configuring project

**First things first**

```git submodule sync --recursive```

```git submodule update --init --recursive```

## How to Run

This project was not meant to be run alone. It is used together with other projects, usually as a git submodule.

Bellow are the list of the currently implemented Makefiles:

 - ans: [ansible](https://www.ansible.com/ "Ansible") related Makefile
 - asn: [El Asno Alado](https://github.com/VivaReal/el-asno-alado "El Asno Alado") related Makefile
 - doc: [docker](https://www.docker.com/ "Docker") related Makefile
 - env: environment related Makefile
 - git: [git](https://git-scm.com/ "git") related Makefile
 - gra: [gradle](https://gradle.org/ "Gradle") related Makefile
 - jmx: [Java Management Extensions](http://www.oracle.com/technetwork/articles/java/javamanagement-140525.html "JMX") related Makefile
 - k8s: [Kubernetes](https://kubernetes.io "k8s")  related Makefile
 - log: logs related Makefile
 - npm: [nodejs' package manager](https://www.npmjs.com/ "npm") related Makefile
 - pro: project workspace related Makefile
 - sbt: [scala build toll](http://www.scala-sbt.org/ "SBT") related Makefile
 - slk: [slack](https://slack.com/ "Slack") related Makefile
 - thr: thread related Makefile
 - usr: [AWS' user-data](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html "User Data") related Makefile

## How to Test

No tests currently implemented

## How to Deploy

Not meant to be deployed
