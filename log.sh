#!/bin/bash -
export GEM_HOME=$HOME/watchdog-ruby/.gems
export RUBYLIB=$HOME/watchdog-ruby/.gems/lib
export PATH=$HOME/watchdog-ruby/.gems/bin:$PATH
/usr/local/bin/ruby1.9 $HOME/watchdog-ruby/logger.rb
