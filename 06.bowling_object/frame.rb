# frozen_string_literal: true

require_relative 'shot'

class Frame
  def initialize(frame)
    @first_shot = Shot.new(frame[0])
    @second_shot = Shot.new(frame[1])
    @third_shot = Shot.new(frame[2])
  end

  def caliculate_sum
    [
      @first_shot.convert_to_number,
      @second_shot.convert_to_number,
      @third_shot.convert_to_number
    ].sum
  end

  def strike?
    @first_shot.convert_to_number == 10
  end

  def spare?
    caliculate_sum == 10 && @first_shot.convert_to_number != 10
  end
end
