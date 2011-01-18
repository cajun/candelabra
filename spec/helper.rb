require 'rubygems'
require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/spec'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'candelabra'
