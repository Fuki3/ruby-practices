# frozen_string_literal: true

require_relative 'file_detail'

class Formatter
  COL = 3

  def initialize(names)
    @names = names
  end

  def format_short
    row_count = @names.size.fdiv(COL)
    max_bytesize = @names.max_by(&:bytesize).bytesize
    cols = @names.each_slice(row_count.ceil)
    lines = Array.new(row_count.ceil) do |idx|
      cols.map do |col|
        col[idx].ljust(max_bytesize)
      end
    end
    lines.each do |name|
      puts name.join(' ')
    end
  end

  def format_long
    puts "total #{file_details.map(&:blocks).sum}"
    @names.each do |name|
      file_detail = file_details.find { |file| file.name == name }
      nlink = file_detail.nlink.to_s.rjust(max_size(:nlink))
      owner = file_detail.owner.ljust(max_size(:owner) + 1)
      group = file_detail.group.ljust(max_size(:group) + 1)
      size = file_detail.size.to_s.rjust(max_size(:size))
      month = format('%2d', file_detail.timestamp.month)
      day = file_detail.timestamp.strftime('%e')
      time = file_detail.timestamp.strftime('%H:%M')
      puts [file_detail.mode, nlink, owner, group, size, month, day, time, name].join(' ')
    end
  end

  private

  def file_details
    @file_details = @names.map { |name| FileDetail.new(name) } unless instance_variable_defined?(:@file_details)
    @file_details
  end

  def max_size(detail)
    file_details.map { |file| file.send(detail).to_s.size }.max
  end
end
