# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(shots)
    @shots = shots
    @frames = frames.map { |n| Frame.new(n) }
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
    frames
  end

  def score
    @frames.each_with_index.sum do |frame, index|
      frame_point = frame.score
      if index >= 9
        # 加算なし
      elsif frame.strike?
        frame_point += caliculate_strike_points(index)
      elsif frame.spare?
        frame_point += caliculate_spare_points(index)
      end
      frame_point
    end
  end

  def caliculate_strike_points(index)
    strike_points = Shot.new(frames[index + 1][0]).score
    x, y = frames[index + 1].size == 1 ? [2, 0] : [1, 1]
    strike_points + Shot.new(frames[index + x][y]).score
  end

  def caliculate_spare_points(index)
    Shot.new(frames[index + 1][0]).score
  end
end
