# This is used to colorize the ouput.
#
# Example usage
#
# "foo".red # => \033[0;31mfoo\033[0m
#
# This code was borrowed from https://github.com/stefanpenner/terminal-color
# A big thanks this was much more sophisticated than my naive approach.
#
# class String
#   def red
#     "\033[0;31m#{self}\033[0m"
#   end
# end
#
# If you need colorization in your app and don't minde dependencies it is highly
# recomended that you use the terminal-color or rainbow gem.

class String
  COLORS = {
    :black     => '0',
    :red       => '1',
    :green     => '2',
    :yellow    => '3',
    :blue      => '4',
    :magenta   => '5',
    :cyan      => '6',
    :white     => '7'
  }

  FORMAT_CODES = {
    :bold      => '1',
    :italic    => '3',
    :underline => '4',
    :blink     => '5',
  }

  def ansi_formatted
    ansi_csi = "#{(0x1B).chr}["
    formats = {}
    FORMAT_CODES.each do |name, code|
      formats[name] = code if @properties[name]
    end
    formats[:color] = "3#{COLORS[@properties[:color]]}" if @properties[:color]
    "#{ansi_csi}#{formats.values.join(';')}m#{self}#{ansi_csi}m"
  end

  def make_colorized(color)
    @properties ||= {}
    @properties[:color] = color
    ansi_formatted
  end

  COLORS.each do |color,v|

    define_method color do
      make_colorized(color)
    end
  end

  FORMAT_CODES.each do |name, code|

    define_method name do
      @properties ||={}
      @properties[name] = true
      ansi_formatted
    end
  end
end

