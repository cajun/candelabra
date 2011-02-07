module Candelabra
  class Runner
    attr_reader :options, :command

    def initialize(args)
      @options = parse args
      @command = ARGV.shift
    end
  
    def parse( args )
      OptionParser.new( args ) do |opts|
        opts.banner = 'Usage: candelabra [command]'


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

    def run
      case command
      when 'start'
        Candelabra::Pianobar.start
      when 'stop'
        Candelabra::Pianobar.stop
      when 'restart'
        Candelabra::Pianobar.restart
      end
    end
  end
end
