require 'pp'

class TairaEscapeeStrategy < EscapeeStrategy
  def initialize
  end

  def next_direction(chaser_positions, escapee_positions)

    near_chaser = chaser_positions.first

    near_chaser_distance = near_chaser[0].abs + near_chaser[1].abs

    return [0, 0] if near_chaser_distance > 5

    points = { [1,0] => 0.0, [-1,0] => 0.0, [0,1] => 0.0, [0,-1] => 0.0 }

    next_candidate = [[1,0], [-1, 0], [0, 1], [0, -1]]

    next_candidate.each do |next_x, next_y|
      chaser_positions.each do |dx, dy|
        next_chaser_x = dx - next_x
        next_chaser_y = dy - next_y
        points[[next_x, next_y]] += next_chaser_x.abs + next_chaser_y.abs
      end
    end
    direction = points.max {|a,b| a[1] <=> b[1] }[0]
    direction
  end
end
