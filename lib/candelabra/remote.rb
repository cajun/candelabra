module Candelabra
  module Remote
    module_function

    def commands 
      {
        :pause => 'p'
      }
    end

    def execute_command cmd
      Candelabra::Pianobar.start unless Candelabra::Pianobar.running?
      `echo #{commands[cmd]} > #{Candelabra::Installer.ctl_path}`
    end

  end
end
