require 'rubygems'
require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/spec'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'candelabra'

def clean_up
  begin
    yield
  ensure
    `killall pianobar`
  end
end

def pid_as_expression
  exp = ''
  Process.pid.to_s.each_char{ |c| exp += "[^#{c}]" }
  exp
end
