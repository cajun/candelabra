module Candelabra
  # The  Pianobar  module  of  Candelabra  handles  starting  and
  # stopping of pianobar. The module  will contain the PID of the
  # process.  It will  also be  able  to kill  of the  pianobar's
  # running on the system
  #
  # For  Example:
  #   Candelabra::Pianobar.start
  #     # => pianobar has started
  module Pianobar
    #  Give me  super  powers and  the ability  to  call all  the
    # methods in this file.
    module_function

    # The accessor  for the PID. If  this is nil then  no process
    # has been started
    #
    # Returns int or nil
    def pid
      return @pid unless @pid.nil?
      @pid = %x[ps -a | grep pianobar$].split(' ').first
      @pid = @pid.to_i unless @pid.nil?
    end

    # Check to determine if pianobar is running anywhere on the system
    #
    # Returns true or false
    def running?
      !pid.nil?
    end

    # Start the  pianobar. ( bet  you couldn't have  guessed that
    # one ) It  will take the output pianobar and  redirect it to
    # logs/out.log in the gem folder.
    #
    # Example:
    #   Candelabra::Pianobar.start
    #     # => gives you the process ID
    #
    # Returns the process ID a.k.a pid
    def start
      make_logs
      @pid = spawn( 'pianobar', :out => 'logs/out.log' )
      ::Process.detach(@pid)
      @pid
    end

    # Die pianobar die!!!! Yeah that is what it does. If you have
    # a PID then this will send the kill command to that process
    #
    # Example:
    #   Candelabra::Pianobar.stop
    #     # => pianobar is done for
    #
    # Returns nothing
    def stop
      ::Process.kill('HUP', pid)
      @pid = nil
    end

    # When killing  one pianobar  is not  enough. Kill  them all.
    # This  will  send  a  system  command to  kill  all  of  the
    # pianobars running on the system.  This is useful because of
    # rouge pianobars and stuff
    #
    # Example:
    #   Candelabra::Pianobar.stop_all
    #     # => and they are all dead
    #
    # Returns nothing useful
    def stop_all
      %x[killall pianobar]
      @pid = nil
    end

    # Util method. Should be moved  to the install module when it
    # has been created.
    #
    # Example:
    #   Candelabra::Pianobar.make_logs
    #     # => doesn't really belong here
    #
    # Returns nothing. but it makes the logs dir
    def make_logs
      Dir.mkdir( 'logs' ) unless test ?d, 'logs'
    end
  end
end
