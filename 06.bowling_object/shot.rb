# frozen_string_literal: true

class Shot
  def put_in_array
    score = ARGV[0]
    scores = score.split(',')
    shots = []
    scores.each do |s|
      if s == 'X'
        shots << 10
        shots << 0
      else
        shots << s.to_i
      end
    end
    shots
  end
end
