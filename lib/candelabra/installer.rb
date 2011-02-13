module Candelabra
  # This  module handles  the installing  of pianobar  Candelabra
  # will support two different ways of installing
  # First is via osx # => brew
  # Second is ubuntu # => apt-get
  #
  # It  will   also  know  if  pianobar   is  installed.  Because
  # packagemanagers are  a good  thing Candelabra will  allow the
  # packagemanage  handle  all the  hard  work  with keeping  the
  # version correct
  #
  # For Example:
  #   Candelabra::Installer.install 'pianobar'
  #     # => brew install pianobar
  #     # => sudo apt-get install pianobar
  module Installer
    module_function

    extend OSX
    extend Ubuntu

    # Executing the installing process.
    def run
      header
      what_is_installed?
    end

    def header
      puts ""
      puts " Installing Candelabra Version #{Candelabra::VERSION} ".center(80,'*')
      puts ""
    end

    # Display what is installed to the user
    #
    # Return if all is ok to install
    def what_is_installed?
      puts " => Detecting OS".ljust(70,'.') + os.green
      puts " => Detecting Package Manager".ljust(70,'.') + ( has_installer? ? 'Yes'.green : 'No'.red.blink )
      puts " => Detecting Pianobar".ljust(70,'.') + ( pianobar? ? 'Yes'.green : 'No'.red.blink )
      puts " => Detecting Control File".ljust(70,'.') + ( ctl? ? 'Yes'.green : 'No'.red.blink )
      puts " => Detecting Notifyer".ljust(70,'.') + ( notify? ? 'Yes'.green : 'No'.red.blink )

      puts "   => Ok to install".ljust(70,'.') + ( has_installer? ? 'Yes'.green : 'No'.red.blink )
      has_installer?
    end

    # Checking to determine  if pianobar is installed  it is just
    # looking for the executable.
    #
    # Example:
    #   Candelabra::Install.pianobar?
    #     # => true if pianobar is in the path
    #
    # Returns true when pianobar is installed
    def pianobar?
      !pianobar_path.empty?
    end

    # Gets the path to pianobar.  If it's installed on the system
    # and in your  path it will be located. This  path is what is
    # used to determine if pianobar needs to be installed
    #
    # Example:
    #   Candelabra::Installer.pianobar_path
    #     # => /usr/local/bin/pianobar
    #
    # Returns a string
    def pianobar_path
      %x[which pianobar]
    end

    # Pianobar can talk  to a remote file. This  will determin if
    # the file is setup.
    #
    # Returns true when setup in the expected location
    def ctl?
      test ?p, ctl_path
    end

    # The path of the control file. This file must be a fifo file
    # inorder for it to be the correct ctl file.
    #
    # Returns the path to the control file
    def ctl_path
      "#{ENV['HOME']}/.config/pianobar/ctl"
    end
  end
end
