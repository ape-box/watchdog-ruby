#!/bin/bash -
export GEM_HOME=$PWD/.gems
export RUBYLIB=$PWD/.gems/lib
export PATH=$PWD/.gems/bin:$PATH
/usr/local/bin/ruby1.9 $PWD/rdog.rb
