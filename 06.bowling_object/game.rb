# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(shots)
    @shots = shots
  end

  def composition_by_frames
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

  def caliculate_point
    @frames = composition_by_frames
    point = 0
    @frames.each_with_index do |frame, index|
      frame_point = Frame.new(frame).caliculate_sum
      if Frame.new(frame).strike? && index < 9
        frame_point += caliculate_strike_points(index)
      elsif Frame.new(frame).spare? && index < 9
        frame_point += caliculate_spare_points(index)
      end
      point += frame_point
    end
    point
  end

  def caliculate_strike_points(index)
    strike_points = Shot.new(@frames[index + 1][0]).convert_to_number
    strike_points += if @frames[index + 1].size == 1
                       Shot.new(@frames[index + 2][0]).convert_to_number
                     else
                       Shot.new(@frames[index + 1][1]).convert_to_number
                     end
    strike_points
  end

  def caliculate_spare_points(index)
    Shot.new(@frames[index + 1][0]).convert_to_number
  end
end
