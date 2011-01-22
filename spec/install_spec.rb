require 'helper'

describe Candelabra::Install do
  it 'should be able to detect the os' do
    Candelabra::Install.has_brew?.must_equal true
  end

  it 'should know the to brew' do
    Candelabra::Install.brew_path.must_match /.*\/bin\/brew$/
  end

  describe 'when pianobar is installed' do
    it 'should know that pianobar is installed' do
      Candelabra::Install.pianobar?.must_equal true
    end
  end
end
