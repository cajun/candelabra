module Candelabra
  # This module contains installer  specific instructions for OSX
  # using home bree Home brew is the best package manager for OSX
  # right  now  and the  package  manager  that  is going  to  be
  # supported. Include this module into your class/module and you
  # will be able to install using home brew.
  #
  # NOTE: This module will only be active if the os is OSX
  module OSX
    module InstanceMethods
      # Installs the  requested package  using home brew.  If the
      # package is  already installed home brew  will not install
      # it
      #
      # Example:
      #   Candelabra::Install.install 'pianobar'
      #     # => brew installs pianobar
      #
      # Returns standard output from home brew
      def install lib
        %x[brew install #{lib}] if has_brew?
      end

      # Gets  the path  of home  brew. If  it's somewere  on your
      # system this  finds it. Candelabra assumes  that you don't
      # use sudo to install the brew packages
      #
      # Example:
      #   Candelabra::Install.brew_path
      #     # => /usr/local/bin/brew
      #
      # Returns a string
      def installer_path
        %x[which brew].chomp
      end

      # Simple check to determine if home brew is installed
      #
      # Example:
      #   Candelabra::Install.has_brew?
      #     # => On osx it should be true
      #     # => On ubuntu it should be false
      #
      # Returns true if home brew is there
      def has_installer?
        !installer_path.nil?
      end

      def os
        'OSX'
      end

      def notify?
        !%x[which growlnotify].chomp.nil?
      end

      # Notify the user using growl
      def notify
        %x[growlnotify -t "Pianobar - #{stationName}" -m "Now Playing: #{artist} - #{title}"]
      end

    end

    # Load the installer methods IF this is the correct OS
    def self.extended klass
      klass.extend( InstanceMethods ) if osx?
    end

    # Load the installer methods IF this is the correct OS
    def self.included klass
      klass.send( :include, InstanceMethods ) if osx?
    end

    # This method will say if the OS is OSX or not
    #
    # Example:
    #   [ On OSX ] osx?
    #     # => true
    #
    #   [ On Linux ] osx?
    #     # => false
    #
    # Returns true for OSX
    def self.osx?
      !( /darwin/ =~ RbConfig::CONFIG["target_os"] ).nil?
    end
  end
end
