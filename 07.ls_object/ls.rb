# frozen_string_literal: true

require 'optparse'
require 'etc'
require_relative 'long_formatter'
require_relative 'short_formatter'

class Ls
  def output
    if option[:l]
      LongFormatter.new(names).format
    else
      ShortFormatter.new(names).format
    end
  end

  private

  def names
    names = option[:a] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    @names = option[:r] ? names.reverse : names
  end

  def option
    opt = OptionParser.new
    option = {}
    opt.on('-a') { |v| option[:a] = v }
    opt.on('-r') { |v| option[:r] = v }
    opt.on('-l') { |v| option[:l] = v }
    opt.parse(ARGV)
    option
  end
end

Ls.new.output
