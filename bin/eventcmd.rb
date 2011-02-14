#!/usr/bin/env ruby

require 'rubygems'
require File.dirname(__FILE__) + '/../lib/candelabra'

runner = Candelabra::EventCmd.new ARGV
runner.run
