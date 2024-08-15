# frozen_string_literal: true

require 'optparse'

def count(information)
  opt = OptionParser.new
  params = {}
  opt.on('-l') { |v| params[:l] = v }
  opt.on('-w') { |v| params[:w] = v }
  opt.on('-c') { |v| params[:c] = v }
  opt.parse(ARGV)
  text_lines = information
  text = text_lines.join
  lines_count = text_lines.size
  words_count = text.split(/\s+/).size
  characters_count = text_lines.join.size
  @output = []
  params = { l: true, c: true, w: true } if params == {}
  { l: lines_count, w: words_count, c: characters_count }.each do |key, value|
    @output.push(output(value)) if params[key] == true
  end
end

def output(element)
  element.to_s.rjust(8)
end

if $stdin.isatty == false
  count($stdin.readlines)
  puts "#{@output.join} "
else
  output_sum = []
  ARGV.each_with_index do |argument, idx|
    File.exist?(argument) ? file = argument : next
    count(File.readlines(file))
    puts "#{@output.join} #{argument}"
    output_sum_element = @output.map { |n| n.delete(' ').to_i }
    output_sum << output_sum_element
    if idx == ARGV.size - 1
      output_sum = output_sum.transpose.map { |n| output(n.inject(:+)) }
      puts "#{output_sum.join} total"
    end
  end
end
