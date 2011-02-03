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

Requirements
----

You need a AWS account, ...

Try it out
----

    testbot_cloud new demo
    cd demo
    # Edit config/...
 
    testbot_cloud start

    # Some default testbot demo project?...

    # Cleanup
    testbot_cloud stop
    cd ..
    rm -rf demo

Features
-----

* TestbotCloud is continuously tested for compability with Ruby 1.8.7, 1.9.2, JRuby 1.5.5 and Rubinius 1.1.1.

