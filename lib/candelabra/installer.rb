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
      Pianobar.stop_all # make sure all are off
      header
      what_is_installed?
      install_pianobar
      setup_config_file
      make_fifos
      setup_auto_play_station
    end

    def header
      puts get_template 'header'
    end

    # Display what is installed to the user
    #
    # Return if all is ok to install
    def what_is_installed?
      which_os        = os.green
      package_manager = ( has_installer?  ? 'Yes'.green : 'No'.red.blink )
      exe_installed   = ( pianobar?       ? 'Yes'.green : 'No'.red.blink )
      ctl_file        = ( ctl?            ? 'Yes'.green : 'No'.red.blink )
      has_notifier    = ( notify?         ? 'Yes'.green : 'No'.red.blink )
      ok              = ( has_installer?  ? 'Yes'.green : 'No'.red.blink )

      puts get_template 'what_is_installed', binding

      has_installer?
    end

    def setup_config_file
      puts get_template 'setup_config_file'
      @username, @password  = ask( "Enter username:" ), ask( "Enter password:", false )
      write_config_file 
    end

    def write_config_file( station = nil )
      FileUtils.mkdir_p piano_path
      FileUtils.mv config_path, backup_config_name if File.exists? config_path
      File.open( config_path, 'w' ) do |f| 
        f.write config_template( station )
      end
    end

    def make_fifos
      mkfifo( ctl_path )    unless ctl?
      mkfifo( output_path ) unless output?
      mkfifo( input_path )  unless input?
    end


    def backup_config_name
      [config_path, @username, Dir.glob(config_path + '*').size.to_s].join('.')
    end

    def config_template( station_id = nil )
      exe_path = "#{File.dirname(__FILE__)}/../../bin/candelabra"
      station  = station_id
      get_template('config', binding)
    end

    def get_template( name, this_binding = nil )
      erb = ERB.new(File.read(File.dirname(__FILE__) + "/templates/#{name}.erb"))
      erb.result this_binding
    end

    def start_pianobar
      if Pianobar.running?
        print "Restarting Pianobar with Autostation".ljust(CONSOLE_WIDTH + 20, '.')
        Pianobar.restart
      else
        print "Starting Pianobar".ljust(CONSOLE_WIDTH - 5, '.')
        Pianobar.start
      end

      5.times do 
        sleep(1)
        putc '.'
      end

      print Pianobar.running? ? "SUCCESS".green : "FAILED".red.blink
    end

    def setup_auto_play_station
      puts "Testing Configuration".center(CONSOLE_WIDTH + 20)
      start_pianobar


      if Pianobar.running?
        `echo '0' > #{Installer.input_path}` # forcing auto selection of the first station
        sleep( 2 )
        puts ''
        puts "Select Auto station".center( CONSOLE_WIDTH + 20, ' ' )
        stations = Remote.stations
        stations.each { |s| puts s }
        
        begin
          result = ask 'Select Station and press ENTER:'
          raise unless result == result.to_i.to_s
          puts "You selected: #{stations[result.to_i]}"
        rescue
          puts "You must enter the number of the station.".red
          puts "You Entered: #{result.red}"
          puts "Try again"
          retry
        end

        Remote.change_station result

        write_config_file( Remote.station_id )

        start_pianobar
      end
    end

    # Install Pianobar and be cool
    def install_pianobar
      print "Installing Pianobar".ljust(CONSOLE_WIDTH, '.')
      install 'pianobar'
      print pianobar? ? 'SUCCESS'.green : 'FAILED'.red.blink
    end

    alias update_pianobar install_pianobar

    # Helper for asking a question
    #
    # Params:
    #   question => the question u want to ask maybe?
    #   visiable => this  will determine if  the output  should be
    #     displayed or not
    #
    # Returns result of the user's input
    def ask( question, visiable=true )
      begin
        `stty echo`
        print question
        `stty -echo` unless visiable
        gets.chomp
      ensure
        `stty echo`
      end
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

    def input?
      test ?p, input_path
    end

    # Pianobar can talk  to a remote file. This  will determin if
    # the file is setup.
    #
    # Returns true when setup in the expected location
    def ctl?
      test ?p, ctl_path
    end

    def piano_path
      "#{ENV['HOME']}/.config/pianobar"
    end

    def config_path
      "#{piano_path}/config"
    end

    def output_path
      "#{piano_path}/output.fifo"
    end

    def input_path
      "#{piano_path}/input.fifo"
    end

    # The path of the control file. This file must be a fifo file
    # inorder for it to be the correct ctl file.
    #
    # Returns the path to the control file
    def ctl_path
      "#{piano_path}/ctl"
    end
  end
end
