module Candelabra
  class EventCmd
    include OSX
    include Ubuntu

    attr_reader :command, :artist, :title, :album, :stationName, :coverArt

    # Inigialize the Event Command with the given command
    # Once we have the command we can preform different actions
    def initialize(args)
      @command = args.shift
    end

    # Run the command.  Part of running the command 
    def run
      parse( $stdin )
      case command
      when 'songstart'
        notify
      end
    end
    
    # Parse out the data from  stdin. This will set instance vars
    # that are named the same as the input from pianobar
    #
    # Retruns nothing
    def parse(data)
      data.each do |key_value|
        key, value = key_value.chomp.split('=')
        key = key
        instance_variable_set( "@#{key}".to_sym, value )
      end
    end

    # The 2011  release of  pianobar supports  album art.  If wen
    # have album are the it will be displayed in the notification
    #
    # Returns nil or the path of the file
    def art_work
      if coverArt
        Dir.glob('*.jpg').each { |imge| File.delete(imge) }
        File.open( 'img.jpg', 'wb' ) { |f| f.write Net::HTTP.get( URI.parse( coverArt ) ) }
        Dir.glob('*.jpg').first
      end
    end
  end
end

