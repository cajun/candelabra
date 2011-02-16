describe Candelabra::Runner do
  after(:each) { Candelabra::Pianobar.stop_all }

  describe 'entering commands at the command line' do
    it 'should have a start command' do
      starter = Candelabra::Runner.new(['start'])
      starter.run
      Candelabra::Pianobar.running?.must_equal true
    end

    it 'should be able to stop' do
      Candelabra::Pianobar.start
      Candelabra::Runner.new(['stop'])
      Candelabra::Pianobar.running?.must_equal false
    end
  end
end
