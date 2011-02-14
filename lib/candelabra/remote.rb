module Candelabra
  module Remote
    module_function

    # This is a  list of avaiable commands for  pianobar The list
    # here is the  list that we are string with.  There are a few
    # more commands but thoses  commands might have multple input
    # request and  we have to figure  out how to do  that for the
    # user
    #
    # Returns hash of commands and key
    def commands 
      {
        :pause          => 'p',
        :continue       => 'p',
        :love           => '+',
        :ban            => '-',
        :bookmark       => 'b',
        :info           => 'i',
        :skip           => 'n',
        :next           => 'n',
        :quit           => 'q',
        :change_station => 's',
        :tired          => 't',
        :upcomming      => 'u',
        :quick_mix      => 'x',
      }
    end

    # Send the command to pianobar through the fifo file.  If Pianobar is not running
    # it will start pianobar, but not send the command.
    #
    # Example:
    #   If pianobar is NOT running
    #   Candelabra::Remote.execute_command :pause
    #     # => just starts pianobar.  It doesn't pause it
    #
    #   If pianobar IS running
    #   Candelabra::Remote.execute_command :pause
    #     # => pauses pianobar
    #
    # Returns command you passed in
    def execute_command cmd 
      return Candelabra::Pianobar.start unless Candelabra::Pianobar.running?
      if commands.include? cmd
        %x[ echo #{commands[cmd]} > #{Candelabra::Installer.ctl_path} ]
      else
        %x[ echo #{cmd} > #{Candelabra::Installer.ctl_path} ]
      end
      cmd
    end

    # Wrapper for all the commands.  This will give you the ability to call the following methods
    #
    # Example:
    #   Candelabra::Remote.pause
    #     # => Candelabra.Remote.execute_command :pause
    #
    #   Candelabra::Remote.love
    #     # => Candelabra.Remote.execute_command :love
    #
    # Returns result of execute_command or method missing
    def method_missing(method,*args)
      if commands.keys.include? method.to_sym
        execute_command method.to_sym
      else
        super method, args
      end
    end

    # When changing stations the user needs to get the list of stations.  
    #
    # Example:
    #   Candelabra::Remote.change_station
    #     # => [ list of stations ]
    #   Candelabra::Remote.change_station 6
    #     # => go to the 6th station
    #
    # Returns list of stations _or_ changes the station to the requested station
    def change_station( station_number = nil )
      if station_number.nil?
        stations
      else
        execute_command( :change_station )
        execute_command( "s" + station_number.to_s ) unless station_number.nil?
      end
    end

    def station_ids
      return @ids unless @ids.nil?
      @ids = []
      stations.each_with_index do |station,index|
        change_station(index)
        @ids << station_id
      end
      pause # this is because the it will play the last station other wise
      @ids
    end

    def station_id
      /(\d+)/ =~ info
      $1
    end

    def info
      execute_command( :info )
      song_info = ''
      output do |io|
        io.lines.each do |line|
          /(Station .+ \(\d+\))/ =~ line
          if $1
            song_info = $1
            break
          end
        end
      end
      song_info
    end

    # Get a list of stations from the system
    # read the station list from the command line
    #
    # Returns an array of stations
    def stations 
      list = [] 
      execute_command( :change_station ) 
      output do |io|
        io.lines.each do |line|
          /(\[\?\])/ =~ line
          break if $1 == '[?]' # this denotes the use input for which station to change to
          list << $1 if /(#{list.size}\).+)/ =~ line
        end
      end
      list
    end

    def flush
      output {|io| io.flush }
    end

    # The out put file for the commands
    # This contains all the output from pianobar
    #
    # Yields and IO reader for pianobar's output
    def output
      File.open( Candelabra::Installer.output_path, 'r+' ) do |io|
        yield( io )
      end
    end

  end
end
