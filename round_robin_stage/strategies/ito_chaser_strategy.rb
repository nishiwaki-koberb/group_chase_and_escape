require 'pp'

class ItoChaserStrategy < ChaserStrategy
  def initialize
    @distance_history = Array.new(5, 0)
    @direction_history = Array.new(5, stay)
    @random_count = 0
    @random_direction = stay
  end

  def set_random
    @random_count = 3
    @random_direction = all.sample
  end

  def next_direction(chaser_positions, escapee_positions)
    return [0,0] if escapee_positions.empty?
    dx, dy = escapee_positions.first
    distance = dx.abs + dy.abs
    add_history @distance_history, distance

    if @distance_history.uniq.size == 1 && @direction_history.uniq.size == 1
      direction = all.sample
    elsif anyone_near_by?(chaser_positions)
      direction = all.sample
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
      direction = candidate.sample
    end
    add_history @direction_history, direction
    direction
  end

  def add_history(history, distance)
    history.shift
    history.push distance
  end

  def anyone_near_by?(positions)
    distances(positions).any?{|i| i < 3 }
  end

  def distance_avg(positions)
    distance_sum = distances(positions).inject(0){|sum, i| sum + 1 }
    distance_sum.to_f / positions.size
  end

  def distances(positions)
    positions.map{|x, y| x.abs + y.abs }
  end

  def r; [1, 0]; end
  def l; [-1, 0]; end
  def u; [0, 1]; end
  def d; [0, -1]; end
  def stay; [0, 0]; end
  def all; [r, l, u, d]; end
end
