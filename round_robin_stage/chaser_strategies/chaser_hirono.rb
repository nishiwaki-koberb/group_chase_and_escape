require 'pp'

class ChaserStrategy

  unless defined? R
    R = [ 1, 0].freeze
    L = [-1, 0].freeze
    U = [0, -1].freeze
    D = [0,  1].freeze
    S = [0,  0].freeze
  end

  @@leader = nil
  @@trickstar = nil

  def initialize
    if @@trickstar.nil?
      @@trickstar = @strategy = TrickStar.new
    elsif @@leader.nil?
      @@leader = @strategy = LeaderStrategy.new
    else
      @strategy = TriangleStrategy.new
    end
  end

  def next_direction(chaser_positions, escapee_positions)
    if escapee_positions.empty?
      [0, 0]
    else
      @strategy.next_direction(chaser_positions, escapee_positions) || [0, 0]
    end
  end

  module Nearest
    def candidates(dx, dy)
      candidates = []
      candidates.push dir_h(dx)
      candidates.push dir_v(dy)
      candidates.compact
    end
    def dir_h(dx)
      if dx > 0
        R
      elsif dx < 0
        L
      else
        nil
      end
    end
    def dir_v(dy)
      if dy > 0
        D
      elsif dy < 0
        U
      else
        nil
      end
    end
    def distance(dx, dy = 0)
      dx, dy = *dx if Array === dx
      Math.sqrt(dx ** 2 + dy ** 2)
    end

    module_function :candidates, :dir_h, :dir_v, :distance
  end

  class RandomStrategy
    def next_direction(chaser_positions, escapee_positions)
      [ S, R, L, U, D, L, D, L ].sample
    end
  end

  class OriginalStrategy
    include Nearest
    def next_direction(chaser_positions, escapee_positions)
      candidates(*escapee_positions.first).sample
    end
  end

  class NearestVerticalStrategy
    include Nearest
    def next_direction(chaser_positions, escapee_positions)
      candidates(*escapee_positions.first).last
    end
  end

  class NearestHorizontalStrategy
    include Nearest
    def next_direction(chaser_positions, escapee_positions)
      candidates(*escapee_positions.first).first
    end
  end

  class NearestStrategy
    include Nearest
    def next_direction(chaser_positions, escapee_positions)
      dx, dy = escapee_positions.first
      cands = candidates(dx, dy)
      addition = dx.abs > dy.abs ? cands.first : cands.last
      cands << addition
      cands.sample
    end
  end

  class Nearest2Strategy < NearestStrategy
    def next_direction(chaser_positions, escapee_positions)
      escapee_positions.shift if 1 < escapee_positions.size
      super(chaser_positions, escapee_positions)
    end
  end

  class MixedStrategy < NearestStrategy
    def next_direction(chaser_positions, escapee_positions)
      dx, dy = escapee_positions.first
      cdx, cdy = chaser_positions.first
      if distance(cdx, cdy) < distance(dx, dy) && 0 <= cdx * dx && 0 <= cdy * dy
        super(chaser_positions, [ escapee_positions.first(2).last ])
      else
        super(chaser_positions, [[dx, dy]])
      end
    end
  end

  class LeaderStrategy < NearestStrategy
    def initialize
      @chasers = Array.new(4, [0, 0])
    end

    def next_direction(chaser_positions, escapee_positions)
      @chasers = chaser_positions.dup
      super
    end

    def find_in(chaser_positions)
      candidates = chaser_positions.select { |cdx, cdy| @chasers.any { |dx, dy| cdx == -dx && cdy == -dy } }
      if 1 < candidates
        candidates2 = candidates.select { |cdx, cdy| chaser_positions.map { |dx, dy| [ -cdx + dx, -cdy + dy ] }.select { |dx, dy| @chasers.any { |tdx, tdy| dx == tdx && dy == tdy } } }
        candidates2.empty? ? candidate.first : candidates2.first
      else
        candidates.first
      end
    end
  end

  class TriangleStrategy < NearestStrategy
    def next_direction(chaser_positions, escapee_positions)
      chasers = (chaser_positions + [ [0, 0] ]).sort_by { |dx, dy| dx }
      ldx, ldy = chasers.first
      escapings = escapee_positions.map {|dx, dy| [ ldx + dx, ldy + dy ] }.sort_by { |dx, dy| dx }
      tdx, tdy = escapings.first
      dx = tdx - ldx
      dy = tdy - ldy
      super(chaser_positions, [[dx, dy]])
    end
  end

  class TrickStar < NearestStrategy
    def next_direction(chaser_positions, escapee_positions)
      [ S, L, D, L, D, L, super(chaser_positions, [escapee_positions.last]) ].sample
    end
  end
end
