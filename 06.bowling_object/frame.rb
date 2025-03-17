# frozen_string_literal: true

require_relative 'shot'

class Frame
  def initialize(frame)
    @first_shot = Shot.new(frame[0]).convert_to_number
    @second_shot = Shot.new(frame[1]).convert_to_number
    @third_shot = Shot.new(frame[2]).convert_to_number
  end

  def caliculate_sum
    [
      @first_shot,
      @second_shot,
      @third_shot
    ].sum
  end

  def strike?
    @first_shot == 10
  end

  def spare?
    caliculate_sum == 10 && @first_shot != 10
  end
end
