require 'helper'

describe Candelabra::Pianobar do
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

end
