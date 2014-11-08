require 'pp'

class ChaserStrategy
  @@count = 0

  attr_accessor :id

  def initialize
    @@count = @@count + 1
    @id = @@count
  end

  def next_direction(chaser_positions, escapee_positions)
    return [0,0] if escapee_positions.empty?
    dx, dy = escapee_positions.first
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
