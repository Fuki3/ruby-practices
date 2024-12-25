# frozen_string_literal: true

require_relative 'shot'

class Frame
  def put_in_frames
    frames = []

    Shot.new.put_in_array.each_slice(2) do |s|
      if Shot.new.put_in_array.size > 20
        break if frames.size == 9
      else
        frames.size == 10
      end
      frames << s
    end
    case Shot.new.put_in_array.size
    when 21
      frames.push([Shot.new.put_in_array[-3], Shot.new.put_in_array[-2], Shot.new.put_in_array[-1]])
    when 22
      frames.push([Shot.new.put_in_array[-4], Shot.new.put_in_array[-2], Shot.new.put_in_array[-1]])
    when 23
      frames.push([Shot.new.put_in_array[-5], Shot.new.put_in_array[-3], Shot.new.put_in_array[-1]])
    when 24
      frames.push([Shot.new.put_in_array[-6], Shot.new.put_in_array[-4], Shot.new.put_in_array[-2]])
    end
    frames
  end
end
