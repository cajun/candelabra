module Candelabra
  module Process
    module_function

    def pid
      @pid
    end

    def start
      make_logs
      @pid = spawn( 'pianobar', :out => 'logs/out.log' )
      ::Process.detach(@pid)
      @pid
    end

    def stop
      ::Process.kill('HUP', @pid)
    end

    def stop_all
      `killall pianobar`
    end

    def make_logs
      Dir.mkdir( 'logs' ) unless test( 'd', 'logs' )
    end
  end
end
