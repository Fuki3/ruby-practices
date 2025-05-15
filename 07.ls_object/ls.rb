# frozen_string_literal: true

require 'optparse'
require 'etc'
require_relative 'formatter'

class Ls
  opt = OptionParser.new
  params = {}
  opt.on('-a') { |v| params[:a] = v }
  opt.on('-r') { |v| params[:r] = v }
  opt.on('-l') { |v| params[:l] = v }
  opt.parse(ARGV)

  formatter = Formatter.new(params)
  formatter.output # (params)
end
