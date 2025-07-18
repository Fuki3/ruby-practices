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

  def max_bytesize
    @names.map(&:bytesize).max
  end

  def set_include_remainder
    cols = @names.each_slice(complete_row_count + 1)
    Array.new(complete_row_count + 1) do |idx|
      cols.map { |col| col[idx] }.compact.map do |name|
        "#{name.ljust(max_bytesize)} "
      end
    end
  end

  def set_without_remainder
    cols = @names.each_slice(complete_row_count)
    Array.new(complete_row_count) do |idx|
      cols.map do |col|
        "#{col[idx].ljust(max_bytesize)} "
      end
    end
  end

  def format_without_l_option
    set_names = (@names.size % COL).zero? ? set_without_remainder : set_include_remainder
    set_names.map { |name| puts name.map(&:to_s).join }
  end

  def format_with_l_option
    max_nlink = @names.map { |name| FileInfo.new(name).nlink.size }.max
    max_owner = @names.map { |name| FileInfo.new(name).owner }.max.size
    max_group = @names.map { |name| FileInfo.new(name).group }.max.size
    max_size = @names.map { |name| FileInfo.new(name).size.to_s.size }.max
    @names.each do |name|
      fileinfo = FileInfo.new(name)
      nlink = ' ' * (max_nlink - fileinfo.nlink.size) + fileinfo.nlink
      owner = fileinfo.owner + ' ' * (max_owner - fileinfo.owner.size + 1)
      group = fileinfo.group + ' ' * (max_group - fileinfo.group.size + 1)
      size = ' ' * (max_size - fileinfo.size.size) + fileinfo.size.to_s
      timestamp = fileinfo.timestamp
      puts [fileinfo.mode, nlink, owner, group, size, timestamp, name].join(' ')
    end
  end
end
