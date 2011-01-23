require 'helper'

describe Candelabra::Installer do
  describe 'with pianobar is installed' do
    it 'should know that pianobar is installed' do
      Candelabra::Installer.pianobar?.must_equal true
    end
  end

  describe 'without pinaobar installed' do
  end

  describe 'OSX' do
    describe 'with brew installed' do
      it 'should be able to detect the os' do
        Candelabra::Installer.has_installer?.must_equal true
      end

      it 'should know the to brew' do
        Candelabra::Installer.installer_path.must_match /.*\/bin\/brew$/
      end
    end

    describe 'without brew installed' do
    end

  end

  describe 'Ubuntu' do
    describe 'with apt-get installed' do
      it 'should be able to detect the os' do
        Candelabra::Installer.has_installer?.must_equal true
      end

      it 'should know the to brew' do
      end
    end

    describe 'without apt-get installed (really this can happen?)' do
    end

  end
end
