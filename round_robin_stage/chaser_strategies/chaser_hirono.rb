require 'pp'

class ChaserStrategy

  R = [ 1, 0].freeze
  L = [-1, 0].freeze
  U = [0, -1].freeze
  D = [0,  1].freeze

  def initialize
    @histories = [ 0.0 ]
  end

  def next_direction(chaser_positions, escapee_positions)
    select_strategy(chaser_positions, escapee_positions)
  end

  private

  def original_strategy(chaser_positions, escapee_positions)
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

  def strategy1(chaser_positions, escapee_positions)
    return [0,0] if escapee_positions.empty?
    escapee_positions.first(2).inject([]) do |candidate, (dx, dy) |
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
      candidate
    end.sample
  end

  def strategy2(chaser_positions, escapee_positions)
    return [0,0] if escapee_positions.empty?
    dx, dy = escapee_positions.first
    if dx.abs < dy.abs
      0 > dx ? L : R
    else
      0 > dy ? D : U
    end
  end

  def select_strategy(chaser_positions, escapee_positions)
    dx, dy = escapee_positions.first
    distance = Math.sqrt(dx ** 2 + dy ** 2)
    result = if @histories.min > distance
      strategy2(chaser_positions, escapee_positions)
    else
      original_strategy(chaser_positions, escapee_positions)
    end
    @histories.push distance
    @histories.shift if @histories.size > 10
    result
  end
end
