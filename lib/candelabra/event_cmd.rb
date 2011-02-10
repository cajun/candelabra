module Candelabra
  class EventCmd
    include OSX
    include Ubuntu

    attr_reader :command, :artist, :title, :album, :stationName

    def initialize(args)
      @command = args.shift
    end


    def run
      parse( $stdin )
      case command
      when 'songstart'
        notify
      end
    end
    
    def parse(data)
      data.each do |key_value|
        key, value = key_value.chomp.split('=')
        key = key
        instance_variable_set( "@#{key}".to_sym, value )
      end
    end

    
  end
end

