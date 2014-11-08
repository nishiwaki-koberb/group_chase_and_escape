require 'pp'

class EscapeeStrategy
  def initialize
  end

  def next_direction(chaser_positions, escapee_positions)
    candidate = [[0,1], [0, -1], [1, 0], [-1, 0]]

    chaser_positions[0..0].each do |dx, dy|
      if dx.abs == dy.abs
        if dx > 0
          candidate.delete([1, 0])
        elsif dx < 0
          candidate.delete([-1, 0])
        end
        return candidate[0] if candidate.count == 1
        if dy > 0
          candidate.delete([0, 1])
        elsif dy < 0
          candidate.delete([0, -1])
        end
      elsif dx.abs > dy.abs
        if dy > 0
          candidate.delete([0, 1])
        else
          candidate.delete([0, -1])
        end
      elsif dx.abs < dy.abs
        if dx > 0
          candidate.delete([1, 0])
        else
          candidate.delete([-1, 0])
        end
      end
      if candidate.count == 1
        return candidate[0]
      end
    end
    candidate.sample
  end
end
