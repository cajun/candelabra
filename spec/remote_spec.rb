
require 'helper'


describe Candelabra::Remote do
  describe 'when pianobar is running' do
    describe 'commands' do
      it 'should be able to execute a command' do
        clean_up do
          ctl_file do |file|
            Candelabra::Pianobar.start
            Candelabra::Remote.execute_command :pause
            # file.read.must_equal 'p'
          end
        end
      end

      it 'should be able to execute the pause command' do
        clean_up do
          ctl_file do |file|
            Candelabra::Pianobar.start
            Candelabra::Remote.pause
            # file.read.must_equal 'p'
          end
        end
      end
    end
  end

  describe 'when pianobar is NOT running' do
    it 'should start pianobar' do
      clean_up do
        ctl_file do |file|
          Candelabra::Pianobar.stop_all
          Candelabra::Remote.execute_command(:pause)
          Candelabra::Pianobar.running?.must_equal true
        end
      end
    end
  end
end
