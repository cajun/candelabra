# Pulling in all the libs we need to get the job done
%w(shell singleton optparse rainbow net/http).each do |lib|
  require lib
end

# NOTE: These must be first.
dir = File.dirname(__FILE__)
require "#{dir}/candelabra/osx.rb"
require "#{dir}/candelabra/ubuntu.rb"

# Requiring all of the files in the lib dir. kinda cool ( i guess
# ). This  way we don't  have to worry  about loading any  of the
# files by hand.
Dir[File.join File.dirname(__FILE__), 'candelabra', '*'].each do |file|
  require file
end
