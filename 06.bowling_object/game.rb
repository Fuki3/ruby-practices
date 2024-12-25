# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize
    @point = point
  end

  def point
    point = 0
    Frame.new.put_in_frames.first(9).each_with_index do |frame, index|
      point += if frame[0] == 10 && Frame.new.put_in_frames[index + 1][0] == 10 && index != 8
                 10 + Frame.new.put_in_frames[index + 1][0] + Frame.new.put_in_frames[index + 2][0]
               elsif frame[0] == 10
                 10 + Frame.new.put_in_frames[index + 1][0] + Frame.new.put_in_frames[index + 1][1]
               elsif frame.sum == 10 # spare
                 10 + Frame.new.put_in_frames[index + 1][0]
               else
                 frame.sum
               end
    end
    point += Frame.new.put_in_frames[9].sum
  end
end
