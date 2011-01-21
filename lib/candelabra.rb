require 'pty'

module Candelabra
  module_function

  def pid
    /^(\d*)pianobar/ =~ system( 'ps | grep pianobar' )
    puts $1
    $1.to_i unless $1.nil?
  end

  def start
    Process.detach fork{ `pianobar` }
  end

  def stop
    Process.kill('HUP', pid)
  end

end


