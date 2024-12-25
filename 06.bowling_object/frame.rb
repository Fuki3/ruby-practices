# frozen_string_literal: true

require_relative 'shot'

class Frame
  def frames
    frames = []

    Shot.new.shots.each_slice(2) do |s|
      if Shot.new.shots.size > 20
        break if frames.size == 9
      else
        frames.size == 10
      end
      frames << s
    end
    case Shot.new.shots.size
    when 21
      frames.push([Shot.new.shots[-3], Shot.new.shots[-2], Shot.new.shots[-1]])
    when 22
      frames.push([Shot.new.shots[-4], Shot.new.shots[-2], Shot.new.shots[-1]])
    when 23
      frames.push([Shot.new.shots[-5], Shot.new.shots[-3], Shot.new.shots[-1]])
    when 24
      frames.push([Shot.new.shots[-6], Shot.new.shots[-4], Shot.new.shots[-2]])
    end
    frames
  end
end
