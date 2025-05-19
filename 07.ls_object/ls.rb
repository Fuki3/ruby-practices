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
    params = {}
    opt.on('-a') { |v| params[:a] = v }
    opt.on('-r') { |v| params[:r] = v }
    opt.on('-l') { |v| params[:l] = v }
    opt.parse(ARGV)
    params
  end
end

ls = Ls.new
ls.format
