require 'pp'

class EscapeeStrategy

  @@subclasses = []

  def self.inherited(child)
    @@subclasses << child
  end

  def self.subclasses
    @@subclasses
  end

  def initialize
  end

  def next_direction(chaser_positions, escapee_positions)
    raise "not implemented"
  end
end

class DefaultEscapeeStrategy < EscapeeStrategy

  def initialize
  end

  def next_direction(chaser_positions, escapee_positions)
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
    candidate.sample
  end
end
