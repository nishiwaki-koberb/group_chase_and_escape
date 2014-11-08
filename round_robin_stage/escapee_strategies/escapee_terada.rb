require 'pp'

class EscapeeStrategy

  def initialize
  end

  def next_direction(chaser_positions, escapee_positions)
    nearest_chaser_pos = chaser_positions.first
    center_of_chasers_pos = center_of_chasers(chaser_positions)

    dx, dy = [nearest_chaser_pos, center_of_chasers_pos].min_by{|pos| pos.map(&:abs).inject(:+)}

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

    all_x, all_y = chaser_positions.transpose
    if all_x.max - all_x.min < 5
      nearest_chaser_pos.first > 0 ? [-1, 0] : [1, 0]
    elsif all_y.max - all_y.min < 5
      nearest_chaser_pos.first > 0 ? [0, -1] : [0, 1]
    else
      candidate.sample
    end
  end

  def center_of_chasers chaser_positions
    chaser_positions.transpose.map{|pos| pos.inject(:+) / chaser_positions.size}
  end
end
