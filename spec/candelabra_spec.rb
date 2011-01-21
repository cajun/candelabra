require 'helper'

describe Candelabra do
  it 'should have a version number' do
    Candelabra::VERSION.must_be_instance_of String
  end

  describe 'the process' do
    before(:each) do
      @pid = Candelabra.start
    end
    
    # Had to do this, because the first test starts a pianobar that never quits.
    # Comment out all but stop test if you're paranoid.
    after(:each) do
      `killall pianobar`
    end

    it 'should start pianobar' do
      `ps -p #{@pid}`.must_match /pianobar/
    end

    it 'should stop pianobar' do
      Candelabra.stop
      `ps -p #{@pid}`.wont_match /pianobar/
    end
  end
end
