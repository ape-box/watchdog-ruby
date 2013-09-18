watchdog-ruby
=============

** WARNING: setup, start and crontab jobs are not working properly! **

## Manual Install istructions for webfaction environment

    git clone https://github.com/ape-box/watchdog-ruby
    cd watchdog-ruby
    mkdir .gems
    export GEM_HOME=$PWD/.gems
    export RUBYLIB=$PWD/.gems/lib
    export PATH=$PWD/.gems/bin:$PATH
    gem1.9 install rb-inotify

and then modify rdog.rb with apropriate options

## Crontab options:

As crontab run with a plain environment you should use start.sh to launch it, so that ruby have the correct environment varibles

My crontab listings:

    MAILTO="myaddress@email.com"
    MAILFROM="myaddress@email.com"

    */30 * * * * /home/alessio/watchdog-ruby/start.sh >> /home/alessio/watchdog-ruby/watch.log
    */30 * * * * /home/alessio/watchdog-ruby/kill.sh >> /home/alessio/watchdog-ruby/watch.log


