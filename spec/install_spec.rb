require 'helper'

describe Candelabra::Install do
  it 'should be able to detect the os' do
    Candelabra::Install.has_brew?.must_equal true
  end

  it 'should know the to brew' do
    Candelabra::Install.brew_path.must_match /.*\/bin\/brew$/
  end
end
