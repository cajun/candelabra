The candelbra is on top of the piano....bar
===========================================

# Candelbra
-  is the  traditional  term  for a  set  of multiple  decorative
candlesticks,  each of  which often  holds  a candle  on each  of
multiple arms or branches connected to a column or pedestal.

This is  not a  candlestick. It  is a  wrapper lib  for pianobar.
I  will   handle  the  installtion,  configuration,   and  remote
controlling of  pianobar. It  can support multiple  user accounts
and the switching between them.

There is a command line access to the lib as well as a ruby api.

## Installation: ##

    $ gem install candelabra

But before you can set the pianobar on fire.

    $ candelabra install

You will be prompted for your username and password.

## Example Usage: ##

#### Starting

    $ candelabra start

#### Stopping

    $ candelabra stop

#### Skipping a song

    $ candelabra next

or if you would prefer

    $ candelabra skip

or better yet

    $ candelabra n

You get the point!

Any of the following commands are currently supported

    def commands
      {
        :pause          => 'p',
        :continue       => 'p',
        :love           => '+',
        :ban            => '-',
        :bookmark       => 'b',
        :info           => 'i',
        :skip           => 'n',
        :next           => 'n',
        :quit           => 'q',
        :tired          => 't',
      }
    end


