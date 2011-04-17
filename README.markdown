Work in progress!
----

This is **work in progress**. [Readme Driven Development](http://tom.preston-werner.com/2010/08/23/readme-driven-development.html)... 

It works and is in active use, but there are a few more things I'd like to fix before it's truly production ready.

WIP docs below
----

A tool for creating [testbot](https://github.com/joakimk/testbot) clusters in the cloud.

Installing
----

    gem install testbot_cloud

Getting started
----

Using AWS EC2:

* Get a AWS account at [http://aws.amazon.com/](http://aws.amazon.com/).
* Create a Key Pair.
* Allow SSH login to a security group. For example: SSH, tcp, 22, 22, 0.0.0.0/0.

Using Brightbox:

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

Shutdown (will only shutdown the servers created by this tool)

    testbot_cloud stop

Gotchas
-----

* Don't create more than 10-15 or so runners at a time (some cloud providers don't allow more than that many connections at once). This might be fixed by batching the creation process in a later version of TestbotCloud.

* Don't create more than 20 runners in total on EC2 as it has a limit by default. See the [EC2 FAQ](http://aws.amazon.com/ec2/faqs) for more info.

Features
-----

* TestbotCloud is continuously tested for compability with Ruby 1.8.7, 1.9.2, JRuby 1.5.5 and Rubinius 1.1.1.
* TestbotCloud is designed to be as reliable as possible when starting and stopping so that you can schedule it with tools like cron and save money.

How to add support for additional cloud computing providers
-----

Basics:

* Look at lib/server/aws.rb and lib/server/brightbox.rb.
* Write you own and add it to lib/server/factory.rb.
* Add fog config suitable for the provider to your config.yml.

When contributing:

* Make sure you have the tests running on your machine (should be just running "bundle" and "rake").
* Write tests.
* Add a config example to the template at lib/templates/config.yml.
* Update this readme.

