module Candelabra
  module_function
  attr_accessor :pid

  def start
    @pid = fork { `pianobar` }
    Process.detach @pid
  end

  def stop
    Process.kill('HUP', @pid)
    Process.wait(@pid)
  end

end


