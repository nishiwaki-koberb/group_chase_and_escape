require 'pp'

class ChaserStrategy
  R = [1, 0]
  L = [-1, 0]
  U = [0, 1]
  D = [0, -1]
  ALL = [R, L, U, D]

  def initialize
    @distance_history = [0, 0, 0, 0, 0]
  end

  def next_direction(chaser_positions, escapee_positions)
    return [0,0] if escapee_positions.empty?
    dx, dy = escapee_positions.first
    distance = dx.abs + dy.abs
    add_history distance
    if @distance_history.uniq.size == 1
      ALL.sample
    else
      candidate = []
      if dx > 0
        candidate.push [1,0]
      elsif dx < 0
        candidate.push [-1,0]
      end
      if dy > 0
        candidate.push [0,1]
      elsif dy < 0
        candidate.push [0,-1]
      end
      candidate.sample
    end
  end

  def add_history(distance)
    @distance_history.shift
    @distance_history.push distance
  end
end
