# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(shots)
    @shots = shots
    @frames = frames
  end

  def frames
    frames = []
    frame = []
    @shots.each do |s|
      if frames.size < 10
        frame << s
        if frame.size == 2 || s == 'X'
          frames << frame
          frame = []
        end
      else
        frames.last << s
      end
    end
    frames.map { |n| Frame.new(n) }
  end

  def score
    @frames.each_with_index.sum do |frame, index|
      frame_point = frame.score
      next_frame = frames[index + 1]
      after_next_frame = frames[index + 2]
      if index >= 9
        # 加算なし
      elsif frame.strike?
        frame_point += frame.caliculate_strike_points(index, next_frame, after_next_frame)
      elsif frame.spare?
        frame_point += frame.caliculate_spare_points(next_frame)
      end
      frame_point
    end
  end
end
