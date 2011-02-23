module Candelabra
  class Server
    attr_reader :pipe

    SERVICE_NAME = '_candelabra._tcp'
    
    def initialize
      @pipe = TCPServer.new nil, 2000
      DNSSD.register 'candelabra', SERVICE_NAME, nil, 2000
    end

    def browse
      replies =[]
      DNSSD.browse( SERVICE_NAME ) do |reply|
        replies << reply
      end
      replies
    end
  
  end
  
end
