require 'rubygems'
require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/pride'

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

def ctl_file
  # TODO: clear out the file before we start using it
  File.open( Candelabra::Installer.ctl_path, ( File::RDONLY | File::NONBLOCK ) ) do |file|
    yield( file )
  end
end
