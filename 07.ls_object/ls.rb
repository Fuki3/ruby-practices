# frozen_string_literal: true

require 'optparse'
require 'etc'
require_relative 'formatter'

class Ls
  def format
    formatter = Formatter.new(option, names)
    formatter.output
  end

  private

  def option
    opt = OptionParser.new
    option = {}
    opt.on('-a') { |v| option[:a] = v }
    opt.on('-r') { |v| option[:r] = v }
    opt.on('-l') { |v| option[:l] = v }
    opt.parse(ARGV)
    option
  end

  def names
    names = option[:a] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    @names = option[:r] ? names.reverse : names
  end
end

ls = Ls.new
ls.format
