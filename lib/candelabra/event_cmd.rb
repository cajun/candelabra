module Candelabra
  class EventCmd
    include OSX
    include Ubuntu

    attr_reader :command, :artist, :title, :album, :stationName, :coverArt

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
      File.open( 'tmp/output', 'w+') do |f|
        data.each do |key_value|
          f.write key_value
          key, value = key_value.chomp.split('=')
          key = key
          instance_variable_set( "@#{key}".to_sym, value )
        end
      end
    end

    
  end
end

