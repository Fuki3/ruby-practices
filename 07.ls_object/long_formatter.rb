# frozen_string_literal: true

require_relative 'file_detail'

class LongFormatter
  def initialize(names)
    @names = names
  end

  def format
    file_details = @names.map { |name| FileDetail.new(name) }
    puts "total #{file_details.map(&:blocks).sum}"
    max_size = calcalate_max_size(file_details)
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

  def calcalate_max_size(file_details)
    %i[nlink owner group size].to_h do |key|
      size = file_details.map { |file| file.send(key).to_s.size }.max
      [key, size]
    end
  end
end
