require 'helper'

describe Candelabra::EventCmd do
  before( :each ) do
    @data = ["artist=Dean Martin\n", "title=Sway\n", "album=Dino: The Essential Dean Martin\n", "stationName=Cake Radio\n", "pRet=1\n", "pRetStr=Everything is fine :)\n", "wRet=1\n", "wRetStr=Everything's fine :)\n", "songDuration=0\n", "songPlayed=0\n", "rating=0\n"]
    @handler = Candelabra::EventCmd.new( [ 'hah' ] )
  end

  it 'should be able to parse ARTIST' do
    @handler.parse @data
    @handler.artist.must_equal 'Dean Martin'
  end

  it 'should be able to parse TITLE' do
    @handler.parse @data
    @handler.title.must_equal 'Sway'
  end

  it 'should be able to parse ALBUM' do
    @handler.parse @data
    @handler.album.must_equal 'Dino: The Essential Dean Martin'
  end
end

