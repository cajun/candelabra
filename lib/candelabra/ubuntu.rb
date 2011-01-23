module Candelabra
  # This  module  contains  installer specific  instructions  for
  # Ubuntu  using home  bree  Home apt_get  is  the best  package
  # manager for  Ubuntu right  now and  the package  manager that
  # is  going to  be  supported. Include  this  module into  your
  # class/module  and you  will  be able  to  install using  home
  # apt_get.
  #
  # NOTE: This module will only be active if the os is Ubuntu
  module Ubuntu
    module InstanceMethods
      # Installs the requested package using home apt_get. If the
      # package  is  already  installed  home  apt_get  will  not
      # install it
      #
      # Example:
      #   Candelabra::Install.install 'pianobar'
      #     # => sudo apt-get install pianobar
      #
      # Returns standard output from home apt_get
      def install lib
        `sudo apt-get install #{lib}` if has_apt_get?
      end

      # Gets the path  of home apt-get. If it's  somewere on your
      # system this  finds it. Candelabra assumes  that you don't
      # use sudo to install the apt_get packages
      #
      # Example:
      #   Candelabra::Install.apt_get_path
      #     # => /usr/bin/apt-get
      #
      # Returns a string
      def installer_path
        %x[which apt-get].chomp
      end

      # Simple check to determine if home apt_get is installed
      #
      # Example:
      #   Candelabra::Install.has_apt_get?
      #     # => On osx it should be true
      #     # => On ubuntu it should be false
      #
      # Returns true if home apt_get is there
      def has_installer?
        !installer_path.nil?
      end
    end

    # Load the installer methods IF this is the correct OS
    def self.extended klass
      klass.extend( InstanceMethods ) if osx?
    end

    # This method will say if the OS is Ubuntu or not
    #
    # Example:
    #   [ On Ubuntu ] osx?
    #     # => true
    #
    #   [ On OSX ] osx?
    #     # => false
    #
    # Returns true for Ubuntu
    def self.osx?
      /linux/ =~ RbConfig::CONFIG["target_os"]
    end
  end
end
