# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(frame)
    @first_shot = Shot.new(frame[0])
    @second_shot = Shot.new(frame[1])
    @third_shot = Shot.new(frame[2])
  end

  def score
    [
      @first_shot,
      @second_shot,
      @third_shot
    ].map(&:score).sum
  end

  def strike?
    @first_shot.score == 10
  end

  def spare?
    score == 10 && @first_shot.score != 10
  end
end
