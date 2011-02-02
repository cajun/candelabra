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
      %x[ echo -n #{commands[cmd]} > #{Candelabra::Installer.ctl_path} ]
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

  end
end
