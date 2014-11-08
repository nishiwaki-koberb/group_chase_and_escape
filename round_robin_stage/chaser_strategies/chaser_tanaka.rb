require 'pp'

class ChaserStrategy

  def initialize
    @count = 0
    @previous_direction = 0
  end

  def distance(position)
    return 9999 if position.nil?  
    position[0].abs + position[1].abs
  end

  # 同じ方向か
  def is_same_direction?(position1, position2)
    dx1, dy1 = position1
    dx2, dy2 = position2
  end

  def next_direction(chaser_positions, escapee_positions)
    return [0,0] if escapee_positions.empty?

    direction = chase_direction(chaser_positions, escapee_positions)

    if @previous_direction == direction
      @count += 1
    end
    @previous_direction = direction

    if @count == 10
      @count = 0
      candidate = [[1,0],[-1,0],[0,1],[0,-1]]
      return candidate.sample
    end
    return direction
  end

  def chase_direction(chaser_positions, escapee_positions)

    nearest_chaser = chaser_positions.first
    nearest_escapee = escapee_positions.first

    nearest_chaser_distance = distance(nearest_chaser)
    nearest_escapee_distance = distance(nearest_escapee)

    if nearest_escapee_distance > nearest_chaser_distance
      # chaserから離れる
      dx, dy = chaser_positions.first
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
    else
      # escapeeに近づく
      dx, dy = escapee_positions.first
      candidate = []
      if dx > 0
        candidate.push [ 1,0]
      elsif dx < 0
        candidate.push [-1,0]
      end
      if dy > 0
        candidate.push [0, 1]
      elsif dy < 0
        candidate.push [0,-1]
      end
      return candidate.sample
    end
  end
end
