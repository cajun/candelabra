module Candelabra
  module Ubuntu
    UBUNTU_COMMANDS = {
      :install => %x[which apt-get].chomp,
    }

    def Ubuntu.included( klass )
      klass::COMMANDS.merge! UBUNTU_COMMANDS
    end
  end
end
