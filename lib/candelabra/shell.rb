module Candelabra
  class Shell
    COMMANDS = { :pianobar => `which pianobar`.chomp }

    def initialize
      self.class.send( :include, OSX ) if osx?
      self.class.send( :include, Ubuntu ) if linux?
    end

    def install lib
      `#{COMMANDS[:install]} install #{lib}`
    end

    def osx?
      /darwin/ =~ RbConfig::CONFIG["target_os"]
    end

    def linux?
      /linux/ =~ RbConfig::CONFIG["target_os"]
    end
  end
end


