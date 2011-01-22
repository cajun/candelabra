require 'helper'

describe Candelabra do
  it 'should have a version number' do
    Candelabra::VERSION.must_be_instance_of String
  end
end
