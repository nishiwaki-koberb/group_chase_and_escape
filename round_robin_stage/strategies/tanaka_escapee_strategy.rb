require 'pp'

class TanakaEscapeeStrategy < EscapeeStrategy

  def initialize
  end

  def distance(position)
    return 9999 if position.nil?  
    position[0].abs + position[1].abs
  end

  def far_direction(position)
    dx, dy = position

    candidate = [[1,0],[-1,0],[0,1],[0,-1]]
    if dx > 0
      candidate.delete([1,0])
    elsif dx < 0
      candidate.delete([-1,0])
    end
    if dy > 0
      candidate.delete([0,1])
    elsif dy < 0
      candidate.delete([0,-1])
    end
    return candidate.sample
  end

  def next_direction(chaser_positions, escapee_positions)
    nearest_chaser = chaser_positions.first
    nearest_escapee = escapee_positions.first

    nearest_chaser_distance = distance(nearest_chaser)
    nearest_escapee_distance = distance(nearest_escapee)

    if nearest_escapee_distance >= nearest_chaser_distance
      if nearest_chaser_distance < 5
        # chaserから離れる
        return far_direction(nearest_chaser)
      end

      candidate = [[1,0],[-1,0],[0,1],[0,-1]]
      return candidate.sample
    else
      # escapeeから離れる
      dx, dy = escapee_positions.first
      candidate = []
      if dx > 0
        candidate.push [-1,0]
      elsif dx < 0
        candidate.push [1,0]
      end
      if dy > 0
        candidate.push [0,-1]
      elsif dy < 0
        candidate.push [0,1]
      end
      return candidate.sample
    end
  end
end
