watchdog-ruby
=============


## Install istructions for webfaction environment

    git clone https://github.com/ape-box/watchdog-ruby
    cd watchdog-ruby
    mkdir .gems
    export GEM_HOME=$PWD/.gems
    export RUBYLIB=$PWD.gems/lib
    export PATH=$PWD.gems/bin:$PATH
    gem1.9 install rb-inotify

and then modify rdog.rb with apropriate options

## Crontab options:
# todo
