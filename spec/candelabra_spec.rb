require 'helper'

describe Candelabra do
  it 'should have a version number' do
    Candelabra::VERSION.must_be_instance_of String
  end

  describe 'the process' do
    before(:each) do
      Candelabra.start
    end

    it 'should start pianobar' do
      `ps -p #{Candelabra.pid}`.must_match /pianobar/
    end

    it 'should stop pianobar' do
      Candelabra.stop
      `ps -p #{Candelabra.pid}`.wont_match /pianobar/
    end
  end
end
