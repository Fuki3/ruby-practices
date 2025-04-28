# frozen_string_literal: true

require 'optparse'
require 'etc'
require_relative 'formatter'
require_relative 'myfile'
class Ls
  attr_reader :params

  opt = OptionParser.new
  params = {}
  opt.on('-a') { |v| params[:a] = v }
  opt.on('-r') { |v| params[:r] = v }
  opt.on('-l') { |v| params[:l] = v }
  opt.parse(ARGV)

  myfile = MyFile.new(params)
  files = myfile.files
  formatter = Formatter.new(files, myfile, params)
  formatter.output
end
