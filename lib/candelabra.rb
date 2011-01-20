require 'pty'

module Candelabra
  module_function

  def pid
    /\d*/ =~ `ps -C pianobar`
    $1
  end

  def start
    `nohup pianobar &`
  end

  def stop
    Process.kill('HUP', pid)
  end

end


