module Candelabra
  class Configuration
    include Singleton

    attr_accessor :auto_restart , :event_handler
    attr_writer :on_song_start, :on_song_finish, :on_error

    class << self
      def go
        set_defaults
        yield self.instance
      end

      def set_defaults
        config = self.instance
        config.auto_restart = true
      end
    end

    def handler?
      !event_handler.nil?
    end

    # Call the event requested by the system
    #
    # Returns what ever the system is configured to or nil
    def call_event( event )
      if handler?
        event_handler.send( event )
      elsif instance_variable_get( "@" + event.to_s ).respond_to?( 'call' )
        instance_variable_get( "@" + event.to_s ).send( :call )
      else
        instance_variable_get( "@" + event.to_s )
      end
    end

    # short cut way of calling the system
    def method_missing( method, *args )
      if method.to_s =~ /on_/
        call_event( method )
      else
        super method, *args
      end
    end

  end
end
