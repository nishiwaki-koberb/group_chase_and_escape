require 'pp'

class ChaserStrategy
  def r; [1, 0]; end
  def l; [-1, 0]; end
  def u; [0, 1]; end
  def d; [0, -1]; end
  def all; [r, l, u, d]; end

  def initialize
    @distance_history = Array.new(5, 0)
  end

  def next_direction(chaser_positions, escapee_positions)
    return [0,0] if escapee_positions.empty?
    dx, dy = escapee_positions.first
    distance = dx.abs + dy.abs
    add_history distance
    if @distance_history.uniq.size == 1
      all.sample
    else
      candidate = []
      if dx > 0
        candidate.push r
      elsif dx < 0
        candidate.push l
      end
      if dy > 0
        candidate.push u
      elsif dy < 0
        candidate.push d
      end
      candidate.sample
    end
  end

  def add_history(distance)
    @distance_history.shift
    @distance_history.push distance
  end
end
