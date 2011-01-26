
require 'helper'


describe Candelabra::Remote do
  after(:each) { Candelabra::Pianobar.stop_all }

  describe 'when pianobar is running' do
    describe 'commands' do
      it 'should be able to execute a command' do
        ctl_file do |file|
          Candelabra::Pianobar.start
          Candelabra::Remote.execute_command :pause
          file.read.chomp.must_equal 'p'
        end
      end
    end
  end

  describe 'when pianobar is NOT running' do
    it 'should start pianobar' do
      ctl_file do |file|
        Candelabra::Pianobar.stop_all
        Candelabra::Remote.execute_command(:pause)
        file.read.chomp.wont_equal 'p'
        Candelabra::Pianobar.running?.must_equal true
      end
    end
  end
end
