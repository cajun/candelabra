require 'helper'

describe Candelabra::Installer do
  it 'should be able to detect the os' do
    Candelabra::Installer.has_installer?.must_equal true
  end

  it 'should know the to brew' do
    Candelabra::Installer.installer_path.must_match /.*\/bin\/brew$/
  end

  describe 'when pianobar is installed' do
    it 'should know that pianobar is installed' do
      Candelabra::Installer.pianobar?.must_equal true
    end
  end
end
