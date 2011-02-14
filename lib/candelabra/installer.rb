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

    CONSOLE_WIDTH = 70

    extend OSX
    extend Ubuntu

    # Executing the installing process.
    def run
      header
      what_is_installed?
      install_pianobar
      setup_config_file
      make_fifos
      setup_auto_play_station
    end

    def header
      puts ""
      puts " Installing Candelabra Version #{Candelabra::VERSION} ".center(CONSOLE_WIDTH + 20,'*')
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

    def setup_config_file
      puts ""
      puts "Configuring Pianobar account".center(CONSOLE_WIDTH + 20, '_')
      puts "Enter your Pandora's account information"
      username, password  = ask( "Enter username:" ), ask( "Enter password:", false )

      config_path = "#{ENV['HOME']}/.config/pianobar/config"
      new_name = [config_path, username, Dir.glob(config_path + '*').size.to_s].join('.')
      FileUtils.mv config_path, new_name if File.exists? config_path
      File.open( config_path, 'w' ) { |f| f.write config_template( username, password ) }
      puts ""
    end

    def make_fifos
      mkfifo( ctl_path )    unless ctl?
      mkfifo( output_path ) unless output?
    end

    def config_template( username, password, station_id = nil )
      @username ||= username
      @password ||= password
      config = %Q{event_command = #{File.dirname(__FILE__)}/../../bin/eventcmd.rb
user = #{@username}
password = #{@password}
}

      config += "autostart_station = #{ station_id }" if station_id
      config
    end

    def setup_auto_play_station
      puts "Testing Configuration".center(CONSOLE_WIDTH, '_')
      Pianobar.stop_all # make sure all are off
      print "Starting Pianobar".ljust(CONSOLE_WIDTH, '.')
      Pianobar.start
      sleep( 2 )
      print Pianobar.running? ? "SUCCESS".color(:green) : "FAILED".color(:red)

      if Pianobar.running?
        Remote.flush
        puts ''
        puts "Select Auto station".center( CONSOLE_WIDTH + 20, ' ' )
        puts 'Select Station and press ENTER:'
        Remote.stations
        id = Remote.station_id
        Remote.pause
        config_path = "#{ENV['HOME']}/.config/pianobar/config"
        File.open( config_path, 'w' ) { |f| f.write config_template( nil, nil, id ) }

        print "Restarting Pianobar".ljust(CONSOLE_WIDTH, '.')
        Pianobar.restart
        print Pianobar.running? ? "SUCCESS".color(:green) : "FAILED".color(:red)
        puts ""
      end
    end

    # Install Pianobar and be cool
    def install_pianobar
      print "Installing Pianobar".ljust(CONSOLE_WIDTH, '.')
      install 'pianobar'
      print pianobar? ? 'SUCCESS'.color(:green) : 'FAILED'.color(:red)
    end

    # Helper for asking a question
    # 
    # Params:
    #   question => the question u want to ask maybe?
    #   visiable => this  will determine if  the output  should be
    #     displayed or not
    #
    # Returns result of the user's input
    def ask( question, visiable=true )
      print question
      `stty -echo` unless visiable
      gets.chomp
    ensure
      `stty echo`
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


    # Util method. Should be moved  to the install module when it
    # has been created.
    #
    # Example:
    #   Candelabra::Pianobar.make_logs
    #     # => doesn't really belong here
    #
    # Returns nothing. but it makes the logs dir
    def mkfifo( path )
      %x[mkfifo "#{path}"]
    end

    def output?
      test ?p, output_path
    end

    def output_path
      "#{ENV['HOME']}/.config/pianobar/output.fifo"
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
