# frozen_string_literal: true

require_relative 'fileinfo'

COL = 3

class Formatter
  def initialize(option)
    @option = option
    names = option[:a] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    @names = option[:r] ? names.reverse : names
  end

  def output
    if @option[:l]
      puts "total #{@names.map { |name| FileInfo.new(name).blocks }.sum}"
      format_with_l_option
    else
      format_without_l_option
    end
  end

  private

  def complete_row_count
    @names.size / COL
  end

  def bytesize_max
    @names.map { |name| name.encode('EUC-JP').bytesize }.max
  end

  def slice(first, final, element_count)
    @names[first..final].each_slice(element_count).to_a
  end

  def set_a_row
    @names.map { |name| "#{name}#{' ' * (bytesize_max - name.encode('EUC-JP').bytesize)} " }
  end

  def set_include_remainder
    col_array_include_remainder = slice(0, ((complete_row_count + 1) * (@names.size / (complete_row_count + 1))) - 1, complete_row_count + 1)
    col_array_without_remainder = slice(((complete_row_count + 1) * (@names.size / (complete_row_count + 1))), -1, complete_row_count + 1)
    col_array = col_array_include_remainder + col_array_without_remainder
    Array.new((complete_row_count + 1)) do |m|
      col_array.map { |k| k[m] }.compact.map { |p| "#{p}#{' ' * (bytesize_max - p.encode('EUC-JP').bytesize)} " }
    end
  end

  def set_without_remainder
    col_array = @names.each_slice(complete_row_count)
    Array.new(complete_row_count) do |m|
      col_array.map { |k| "#{k[m]}#{' ' * (bytesize_max - (k[m]).encode('EUC-JP').bytesize)} " }
    end
  end

  def format_without_l_option
    if @names.size <= COL
      puts set_a_row.join
    elsif (@names.size % COL).zero?
      set_without_remainder.map { |name| puts name.map(&:to_s).join }
    else
      set_include_remainder.map { |name| puts name.map(&:to_s).join }
    end
  end

  def format_with_l_option
    @nlink_max = @names.map { |name| FileInfo.new(name).nlink.size }.max
    @owner_max = @names.map { |name| FileInfo.new(name).owner }.max.size
    @group_max = @names.map { |name| FileInfo.new(name).group }.max.size
    @size_max = @names.map { |name| FileInfo.new(name).size.to_s.size }.max
    @names.each do |name|
      fileinfo = FileInfo.new(name)
      nlink = ' ' * (@nlink_max - fileinfo.nlink.size) + fileinfo.nlink
      owner = fileinfo.owner + ' ' * (@owner_max - fileinfo.owner.size + 1)
      group = fileinfo.group + ' ' * (@group_max - fileinfo.group.size + 1)
      size = ' ' * (@size_max - fileinfo.size.size) + fileinfo.size.to_s
      timestamp = fileinfo.timestamp
      puts [fileinfo.mode, nlink, owner, group, size, timestamp, name].join(' ')
    end
  end
end
