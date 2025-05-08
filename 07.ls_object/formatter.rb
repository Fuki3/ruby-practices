# frozen_string_literal: true

COL = 3

class Formatter
  def initialize(files, fileinfo)
    @fileinfo = fileinfo
    @files = files
    @element_number = files.size / COL
    @remainder = files.size % COL
  end

  def set_a_row
    @files.map { |file| "#{file}#{' ' * (@fileinfo.count_size_max - @fileinfo.count_bytesize(file))} " }
  end

  def set_include_remainder
    col_array_include_remainder = @fileinfo.slice(0, ((@element_number + 1) * (@files.size / (@element_number + 1))) - 1, @element_number + 1)
    col_array_without_remainder = @fileinfo.slice(((@element_number + 1) * (@files.size / (@element_number + 1))), -1, @element_number + 1)
    col_array = col_array_include_remainder + col_array_without_remainder
    Array.new((@element_number + 1)) do |m|
      col_array.map { |k| k[m] }.compact.map { |p| "#{p}#{' ' * (@fileinfo.count_size_max - @fileinfo.count_bytesize(p))} " }
    end
  end

  def set_without_remainder
    col_array = @files.each_slice(@element_number)
    Array.new(@element_number) do |m|
      col_array.map { |k| "#{k[m]}#{' ' * (@fileinfo.count_size_max - @fileinfo.count_bytesize(k[m]))} " }
    end
  end

  def format_without_l_option
    if @files.size <= COL
      puts set_a_row.join
    elsif @remainder.zero?
      set_without_remainder.map { |array| puts array.map(&:to_s).join }
    else
      set_include_remainder.map { |array| puts array.map(&:to_s).join }
    end
  end

  def output(params)
    if params[:l]
      @fileinfo.set_filedetail
    else
      format_without_l_option
    end
  end
end
