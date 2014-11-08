require 'pp'

class EscapeeStrategy

  def initialize
  end

  def next_direction(chaser_positions, escapee_positions)
    # dx, dy = chaser_positions.first
    # dx, dy = center_of_3chasers chaser_positions
    dx, dy = center_of_chasers(chaser_positions).map{|i| i * -1}

    candidate = [[1,0],[-1,0],[0,1],[0,-1]]
    if dx > 0
      # candidate.delete([1,0])
      candidate.delete([-1,0])
    elsif dx < 0
      # candidate.delete([-1,0])
      candidate.delete([1,0])
    end
    if dy > 0
      # candidate.delete([0,1])
      candidate.delete([0,-1])
    elsif dy < 0
      # candidate.delete([0,-1])
      candidate.delete([0,1])
    end
    candidate.sample
  end

  def center_of_chasers chaser_positions
    chaser_positions.transpose.map{|pos| pos.inject(:+) / chaser_positions.size}
  end


end
