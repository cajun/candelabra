require 'helper'

describe Candelabra::Pianobar do
  after( :each ) { Candelabra::Pianobar.stop_all }

  describe 'starting the process' do
    it 'should start pianobar and find it by the pid' do
      clean_up do
        pid = Candelabra::Pianobar.start
        `ps`.must_match /\s#{pid}\s/
      end
    end

    it 'should start pianobar and find it by the pid from the reader' do
      clean_up do
        Candelabra::Pianobar.start
        `ps`.must_match /\s#{Candelabra::Pianobar.pid}\s/
      end
    end

    it 'should start pianobar and find it by the process name' do
      clean_up do
        Candelabra::Pianobar.start
        `ps`.must_match /pianobar$/
      end
    end
  end

  describe 'stoping the process' do
    it 'should stop pianobar' do
      pid = Candelabra::Pianobar.start
      Candelabra::Pianobar.stop
      `ps`.wont_match /#{pid}\s/
    end

    it 'should be able to stop all pianobars' do
      Candelabra::Pianobar.start
      Candelabra::Pianobar.start
      Candelabra::Pianobar.stop_all
      `ps`.wont_match /(pianobar)$/
    end
  end

  describe 'checking the running process' do
    it 'should know when pianobar is running' do
      clean_up do
        Candelabra::Pianobar.start
        Candelabra::Pianobar.running?.must_equal true
      end
    end

    it 'should know when pianobar is not running' do
      Candelabra::Pianobar.stop_all
      Candelabra::Pianobar.running?.must_equal false
    end
  end

end
