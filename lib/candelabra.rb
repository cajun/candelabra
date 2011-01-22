# Requiring all of the files in the lib dir.
# kinda cool ( i guess ).  This way we don't have to
# worry about loading any of the files by hand.
Dir[File.join File.dirname(__FILE__), 'candelabra', '*'].each do |file|
  require file
end
