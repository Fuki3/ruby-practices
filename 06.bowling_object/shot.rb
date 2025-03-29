# frozen_string_literal: true

class Shot
  def initialize(pins)
    @pins = pins
  end

  def score
    @pins == 'X' ? 10 : @pins.to_i
  end
end
