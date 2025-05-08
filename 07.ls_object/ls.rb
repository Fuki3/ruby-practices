# frozen_string_literal: true

require 'optparse'
require 'etc'
require_relative 'formatter'
require_relative 'fileinfo'
class Ls
  opt = OptionParser.new
  params = {}
  opt.on('-a') { |v| params[:a] = v }
  opt.on('-r') { |v| params[:r] = v }
  opt.on('-l') { |v| params[:l] = v }
  opt.parse(ARGV)

  fileinfo = FileInfo.new(params)
  files = fileinfo.files
  formatter = Formatter.new(files, fileinfo)
  formatter.output(params)
end
