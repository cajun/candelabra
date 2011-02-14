module Candelabra
  # This class gives access to candelabra from the command line
  # It has several useful functions like starting, stoping, and
  # firing events to candelabra
  #
  # Examples:
  #   candelabra start
  #     # => I will let you guess what this one does
  #
  #   candelabra stop
  #     # => Yup it does that you are thinking
  #
  #   candelabra restart
  #     # => see above
  #
  #   candelabra event -e on_error
  #     # => send an error event to candelabra
  class Runner
    attr_reader :config, :options, :command, :data

    # Set up the running for Candelabra.  Parse out command and
    # get all the data required for any command
    #
    # Returns...it's the initializer
    def initialize(args)
      @config  = parse args
      @command = args.shift
      @data    = args
    end

    # Take in the arguments from the command line and parse out any
    # options and set up the options hash
    #
    # Returns parsed optionr
    def parse( args )
      @options ={}
      Candelabra::Configuration.go do |config|
        OptionParser.new( args ) do |opts|
          opts.banner = 'Usage: candelabra [command] [opts]'

          opts.on( '-e','--event [EVENT=DATA]',
                  'Send the EVENT to Candelabra.',
                  'if the extra DATA is supplied',
                  'set the EVENT to the DATA.' ) do |event_command|

            event, cmd = event_command.split('=')
            config.send( event + '=', cmd ) if cmd
            @options[event] = true
          end

          opts.on_tail( '-h', '--help', 'Show this message' ) do
            puts opts
            exit
          end

          opts.on_tail( '-v', '--version', 'Show Candelabra Version' ) do
            puts "Candelabra's Version is: #{ Candelabra::VERSION }"
            exit
          end

        end.parse!
      end

      Candelabra::Configuration.instance
    end

    # Execute the  given command. Also  fire off any  events that
    # occur in the system
    #
    # Returns nothing special
    def run
      case command
      when 'start'
        Candelabra::Pianobar.start
      when 'stop'
        Candelabra::Pianobar.stop
      when 'restart'
        Candelabra::Pianobar.restart
      when 'install'
        Candelabra::Installer.run
      when 'event'
        # NOTE: this is mainly for debugging
        puts "On Song Start: #{ config.on_song_start }" if options['on_song_start']
        puts "On Song Finish: #{ config.on_song_finish }" if options['on_song_finish']
        puts "On Error: #{ config.on_error }" if options['on_error']
      else
        puts "No command given"
      end
    end
  end
end
