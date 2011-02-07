require 'helper'

describe Candelabra::Configuration do
  before(:each) do
    Candelabra::Configuration.go { |config| } 
    @config = Candelabra::Configuration.instance 
  end

  describe 'setting up configuration' do
    it 'should be able to set "auto_restart"' do
      Candelabra::Configuration.go do |config|
        config.auto_restart = false
      end

      @config.auto_restart.must_equal false
    end

    describe 'events' do
      it 'should be able to set "on_song_start" to a lambda' do
        Candelabra::Configuration.go do |config|
          config.on_song_start = lambda { 'song_started' }
        end

        @config.on_song_start.must_equal 'song_started'
      end

      it 'should be able to set "on_song_start" to a primitive' do
        Candelabra::Configuration.go do |config|
          config.on_song_start = 'another_song'
        end

        @config.on_song_start.must_equal 'another_song'
      end

      it 'should be able to set "on_song_finish" to a lambda' do
        Candelabra::Configuration.go do |config|
          config.on_song_finish = lambda { 'song_finished' }
        end

        @config.on_song_finish.must_equal 'song_finished'
      end

      it 'should be able to set "on_song_finish" to a primitive' do
        Candelabra::Configuration.go do |config|
          config.on_song_finish = 'another_song_is_done'
        end

        @config.on_song_finish.must_equal 'another_song_is_done'
      end
    end

  end

  describe 'event handler' do
    it 'should be able to set "event_handler"' do
      handler = Object.new
      Candelabra::Configuration.go do |config|
        config.event_handler = handler
      end

      @config.event_handler.must_equal handler
    end

    it 'should have a handler' do
      Candelabra::Configuration.go do |config|
        config.event_handler = Object.new
      end

      @config.handler?.must_equal true
    end

    it 'should call the handler "on_song_start"' do
      handler = OpenStruct.new :on_song_start => 'song_started'
      Candelabra::Configuration.go do |config|
        config.event_handler = handler
      end
      
      @config.on_song_start.must_equal 'song_started'
    end
  end
end
