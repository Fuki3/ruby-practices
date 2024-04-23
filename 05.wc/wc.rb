# frozen_string_literal: true

require 'optparse'

opt = OptionParser.new
params = {}
opt.on('-l') { |v| params[:l] = v }
opt.on('-w') { |v| params[:w] = v }
opt.on('-c') { |v| params[:c] = v }
opt.parse(ARGV)

def count(information)
  text_lines = information
  text = text_lines.join
  @lines_count = text_lines.size
  @words_count = text.split(/\s+/).size
  @characters_count = text_lines.join.size
end

def output(element)
  element.to_s.rjust(8)
end

def params_true(array, element, option)
  array.push(element) if option == true
end

if $stdin.isatty == false
  count($stdin.readlines)
  if params[:l].nil? && params[:w].nil? && params[:c].nil?
    output = [output(@lines_count), output(@words_count), output(@characters_count)]

  else
    output = []
    params_true(output, output(@lines_count), params[:l])
    params_true(output, output(@words_count), params[:w])
    params_true(output, output(@characters_count), params[:c])
  end
  puts "#{output.join} "
else
  @output_l_sum = []
  @output_w_sum = []
  @output_c_sum = []
  @output_params_sum = []
  ARGV.each_with_index do |argument, idx|
    File.exist?(argument) ? file = argument : next
    count(File.readlines(file))
    @output_params = []
    if params[:l].nil? && params[:w].nil? && params[:c].nil?
      output = [output(@lines_count), output(@words_count), output(@characters_count)]
      @output_l_sum << @lines_count
      @output_w_sum << @words_count
      @output_c_sum << @characters_count
      @output_sum = [output(@output_l_sum.sum), output(@output_w_sum.sum), output(@output_c_sum.sum)] if idx == ARGV.size - 1
    else
      params_true(@output_params, output(@lines_count), params[:l])
      params_true(@output_params, output(@words_count), params[:w])
      params_true(@output_params, output(@characters_count), params[:c])
      @output_l_sum.push([@lines_count].sum) if params[:l] == true
      @output_params_sum << (@output_l_sum.sum) if idx == ARGV.size - 1 && params[:l] == true
      @output_w_sum.push([@words_count].sum) if params[:w] == true
      @output_params_sum << @output_w_sum.sum if idx == ARGV.size - 1 && params[:w] == true
      @output_c_sum.push([@characters_count].sum) if params[:c] == true
      @output_params_sum << (@output_c_sum.sum) if idx == ARGV.size - 1 && params[:c] == true
      @output_sum = @output_params_sum.map { |n| output(n).to_s }
    end
    output = @output_params if !params[:l].nil? || !params[:w].nil? || !params[:c].nil?
    puts "#{output.join} #{argument}"
    puts "#{@output_sum.join} Total" if idx == ARGV.size - 1 && output != @output_sum
  end
end
