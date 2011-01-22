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
  #   Candelabra::Install.pianobar
  #     # => brew install pianobar
  #     # => sudo apt-get install pianobar
  module Install
    module_function

    # Simple check to determine if home brew is installed
    #
    # Example:
    #   Candelabra::Install.has_brew?
    #     # => On osx it should be true
    #     # => On ubuntu it should be false
    #
    # Returns true if home brew is there
    def has_brew?
      !brew_path.nil?
    end

    # Gets the path of home brew.  If it's somewere on your system
    # this finds it.  Candelabra assumes that you don't use sudo
    # to install the brew packages
    #
    # Example:
    #   Candelabra::Install.brew_path
    #     # => /usr/local/bin/brew
    def brew_path
      `which brew`.chomp
    end
  end
end
