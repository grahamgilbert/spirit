#!/usr/bin/env rackup
#\ -o 0.0.0.0 -p 60080
# encoding: utf-8

# This file can be used to start Padrino,
# just execute it from the command line.

require File.expand_path("../config/boot.rb", __FILE__)

run Padrino.application
