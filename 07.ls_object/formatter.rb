# frozen_string_literal: true

require_relative 'file_detail'

class Formatter
  COL = 3

  def initialize(names)
    @names = names
  end

  def format_short
    row_count = @names.size.ceildiv(COL)
    max_bytesize = @names.max_by(&:bytesize).bytesize
    cols = @names.each_slice(row_count)
    lines = Array.new(row_count) do |idx|
      cols.map do |col|
        col[idx].ljust(max_bytesize)
      end
    end
    lines.each do |name|
      puts name.join(' ')
    end
  end

  def format_long
    file_details = @names.map { |name| FileDetail.new(name) }
    puts "total #{file_details.map(&:blocks).sum}"
    max_size = culculate_max_size(file_details)
    file_details.each do |file_detail|
      name = file_detail.name
      nlink = file_detail.nlink.to_s.rjust(max_size[:nlink])
      owner = file_detail.owner.ljust(max_size[:owner] + 1)
      group = file_detail.group.ljust(max_size[:group] + 1)
      size = file_detail.size.to_s.rjust(max_size[:size])
      timestamp = file_detail.timestamp.strftime('%_m %e %H:%M')
      puts [file_detail.mode, nlink, owner, group, size, timestamp, name].join(' ')
    end
  end

  private

  def culculate_max_size(file_details)
    %i[nlink owner group size].to_h do |key|
      [key, file_details.map { |file| file.send(key).to_s.size }.max]
    end
  end
end
