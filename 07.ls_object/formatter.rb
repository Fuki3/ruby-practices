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
    @names.map(&:bytesize).max
  end

  def set_include_remainder
    col_array = @names.each_slice(complete_row_count + 1)
    Array.new(complete_row_count + 1) do |idx|
      col_array.map { |col| col[idx] }.compact.map do |name|
        "#{name.ljust(bytesize_max)} "
      end
    end
  end

  def set_without_remainder
    col_array = @names.each_slice(complete_row_count)
    Array.new(complete_row_count) do |idx|
      col_array.map do |col|
        "#{col[idx].ljust(bytesize_max)} "
      end
    end
  end

  def format_without_l_option
    set_names = (@names.size % COL).zero? ? set_without_remainder : set_include_remainder
    set_names.map { |name| puts name.map(&:to_s).join }
  end

  def format_with_l_option
    nlink_max = @names.map { |name| FileInfo.new(name).nlink.size }.max
    owner_max = @names.map { |name| FileInfo.new(name).owner }.max.size
    group_max = @names.map { |name| FileInfo.new(name).group }.max.size
    size_max = @names.map { |name| FileInfo.new(name).size.to_s.size }.max
    @names.each do |name|
      fileinfo = FileInfo.new(name)
      nlink = ' ' * (nlink_max - fileinfo.nlink.size) + fileinfo.nlink
      owner = fileinfo.owner + ' ' * (owner_max - fileinfo.owner.size + 1)
      group = fileinfo.group + ' ' * (group_max - fileinfo.group.size + 1)
      size = ' ' * (size_max - fileinfo.size.size) + fileinfo.size.to_s
      timestamp = fileinfo.timestamp
      puts [fileinfo.mode, nlink, owner, group, size, timestamp, name].join(' ')
    end
  end
end
