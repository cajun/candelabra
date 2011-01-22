module Candelabra
  module OSX
    OSX_COMMANDS = {
      :install => %x[which brew].chomp,
    }

    def OSX.included( klass )
      klass::COMMANDS.merge! OSX_COMMANDS
    end
  end
end
