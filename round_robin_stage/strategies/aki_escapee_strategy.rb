require 'pp'

class AkiEscapeeStrategy < EscapeeStrategy

  def next_direction(chaser_positions, escapee_positions)
    dx, dy = chaser_positions.shift
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

    if candidate.size >= 2
      candidate2 = candidate.clone
      if chaser_positions.size > 0
        dx, dy = chaser_positions.shift
        if dx > 0
          candidate2.delete([1,0])
        elsif dx < 0
          candidate2.delete([-1,0])
        end
        if dy > 0
          candidate2.delete([0,1])
        elsif dy < 0
          candidate2.delete([0,-1])
        end
      end

      if candidate2.size > 0
        candidate = candidate2
      end
    end

    candidate.sample
  end
end
