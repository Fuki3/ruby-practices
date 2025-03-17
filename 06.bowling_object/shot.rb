# frozen_string_literal: true

class Shot
  def initialize(pins)
    @pins = pins
  end

  def convert_to_number
    @pins == 'X' ? 10 : @pins.to_i
  end
end
