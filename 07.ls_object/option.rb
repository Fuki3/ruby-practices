# frozen_string_literal: true

class Option
  def initialize(params)
    @params = params
  end

  def a?
    @params[:a]
  end

  def r?
    @params[:r]
  end

  def l?
    @params[:l]
  end
end
