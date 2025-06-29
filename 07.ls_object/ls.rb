# frozen_string_literal: true

require 'optparse'
require 'etc'
require_relative 'formatter'

class Ls
  def format
    formatter = Formatter.new(option)
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
end

ls = Ls.new
ls.format
