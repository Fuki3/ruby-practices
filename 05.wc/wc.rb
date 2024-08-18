# frozen_string_literal: true

require 'optparse'

def params
  opt = OptionParser.new
  params = {}
  opt.on('-l') { |v| params[:l] = v }
  opt.on('-w') { |v| params[:w] = v }
  opt.on('-c') { |v| params[:c] = v }
  opt.parse(ARGV)
  params
end

def count(text_lines)
  text = text_lines.join
  lines_count = text_lines.size
  words_count = text.split(/\s+/).size
  characters_count = text_lines.join.size
  { l: lines_count, w: words_count, c: characters_count }
end

def output_result(text_lines)
  output = []
  options = params.empty? ? { l: true, c: true, w: true } : params
  options_count = count(text_lines)
  options_count.each do |key, value|
    output.push(value) if options[key]
  end
  output
end

def output(element)
  element.to_s.rjust(8)
end

if $stdin.isatty
  output_sum = []
  ARGV.each do |file|
    next if File.exist?(file) == false

    options_numbers = output_result(File.readlines(file))
    puts "#{options_numbers.map { |n| output(n) }.join} #{file}"
    output_sum << options_numbers
  end
  output_sum = output_sum.transpose.map { |n| output(n.inject(:+)) }
  puts "#{output_sum.join} total"
else
  puts output_result($stdin.readlines).map { |n| output(n) }.join
end
