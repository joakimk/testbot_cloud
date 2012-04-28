![Build status](https://secure.travis-ci.org/joakimk/testbot_cloud.png)

A tool for creating and managing [testbot](https://github.com/joakimk/testbot) clusters in the cloud.

TestbotCloud is based around the idea that you have a project folder for each cluster (which you can store in version control). You then use the "testbot_cloud" command to start and stop the cluster.

The motivation behind this tool, besides making distributed testing simpler is to be able to run a cluster only when it's needed (by scheduling it with tools like cron).

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

Creating a cluster
----

Create a project

    testbot_cloud new demo

    # create  demo/config.yml
    # create  demo/.gitignore
    # create  demo/bootstrap/runner.sh

Start

    cd demo
    testbot_cloud start
    
    # Starting 1 runners...
    # i-dd2222dd is being created...
    # i-dd2222dd is up, installing testbot...
    # i-dd2222dd ready.
  
Shutdown

    testbot_cloud stop

    # Shutting down i-dd2222dd...

Debugging
----

  * Run **DEBUG=true testbot_cloud start** to show all SSH commands and output.

Gotchas
-----

* Don't create more than 10-15 or so runners at a time (some cloud providers don't allow more than that many connections at once). This might be fixed by batching the creation process in a later version of TestbotCloud.

* Don't create more than 20 runners in total on EC2 as it has a limit by default. See the [EC2 FAQ](http://aws.amazon.com/ec2/faqs) for more info.

Features
-----

* TestbotCloud is continuously tested for compatibility with Ruby 1.8.7, 1.9.2, 1.9.3, JRuby 1.6.2 and Rubinius 1.2.3. I'm also trying out travis-ci at http://travis-ci.org/#!/joakimk/testbot_cloud.
* TestbotCloud is designed to be as reliable as possible when starting and stopping so that you can schedule it with tools like cron and save money.

How to add support for additional cloud computing providers
-----

Basics:

* Look at lib/server/aws.rb and lib/server/brightbox.rb.
* Write your own and add it to lib/server/factory.rb.
* Add fog config suitable for the provider to your config.yml.

When contributing:

* Make sure you have the tests running on your machine (should be just running "bundle" and "rake").
* Write tests.
* Add a config example to the template at lib/templates/config.yml.
* Update this readme.
