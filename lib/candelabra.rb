module Candelabra
  module_function

  def start
    @pid = fork do
      exec("pianobar")
    end
  end

  def stop
    Process.kill('HUP', @pid)
    Process.wait(@pid)
  end

end


