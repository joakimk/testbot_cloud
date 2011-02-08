Work in progress!
----

This is **work in progress and not usable yet**. [Readme Driven Development](http://tom.preston-werner.com/2010/08/23/readme-driven-development.html)... 

Until this is done, you can use the [cloud_bot](https://github.com/joakimk/cloud_bot) prototype.

WIP docs below
----

A tool for creating [testbot](https://github.com/joakimk/testbot) clusters in the cloud.

Installing
----

    gem install testbot_cloud

Getting started
----

To use AWS EC2:
* Get a AWS account at [http://aws.amazon.com/](http://aws.amazon.com/).
* Create a "Key Pair" that is only used for testbot. It will be used to identify which servers to shutdown when the cluster is stopped.
* Allow SSH login to a security group. For example: SSH, tcp, 22, 22, 0.0.0.0/0.

To use Brightbox:
* Get a beta account at [http://beta.brightbox.com/beta](http://beta.brightbox.com/beta).
* Follow [http://docs.brightbox.com/guides/getting_started](http://docs.brightbox.com/guides/getting_started) to setup a SSH key.
* Todo...

Creating a cluster
----

Create a project

    testbot_cloud new demo
    cd demo

    # Edit config.yml and bootstrap/* files.

Start

    testbot_cloud start

Status

    testbot_cloud status

Shutdown

    testbot_cloud stop

Features
-----

* TestbotCloud is continuously tested for compability with Ruby 1.8.7, 1.9.2, JRuby 1.5.5 and Rubinius 1.1.1.

