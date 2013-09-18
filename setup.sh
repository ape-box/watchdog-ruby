#!/bin/bash -
mkdir .gems
export GEM_HOME=$PWD/.gems
export RUBYLIB=$PWD/.gems/lib
export PATH=$PWD/.gems/bin:$PATH
gem1.9 install rb-inotify
