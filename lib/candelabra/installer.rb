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
