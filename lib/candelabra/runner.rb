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
      parse(args)
      @command = args.shift
      @data = args
    end

    def banner
      Installer.get_template 'banner'
    end

    # Take in the arguments from the command line and parse out any
    # options and set up the options hash
    #
    # Returns parsed optionr
    def parse( args )
      @options ={}
      Candelabra::Configuration.go do |config|
        OptionParser.new( args ) do |opts|
          opts.banner = banner 

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
      # here comes brute
      cmds = Remote.commands.keys.map{|x| x.to_s }.abbrev
      case command
      when 'start'
        Candelabra::Pianobar.start
      when 'stop'
        Candelabra::Pianobar.stop_all
      when 'restart'
        Candelabra::Pianobar.restart
      when 'flush' # Force flushing of the fifo files
        Candelabra::Remote.flush_all
      when 'install'
        Candelabra::Installer.run
      when *cmds.keys
        if data.nil? || data.empty?
          puts Remote.send cmds[command].to_sym
        else
          puts Remote.send cmds[command].to_sym, data
        end
      else
        puts "No command given"
      end
    end
  end
end
