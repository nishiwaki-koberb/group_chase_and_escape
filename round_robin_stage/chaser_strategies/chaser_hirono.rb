require 'pp'

class ChaserStrategy

  unless defined? R
    R = [ 1, 0].freeze
    L = [-1, 0].freeze
    U = [0, -1].freeze
    D = [0,  1].freeze
  end

  @@random = false

  def initialize
    if @@random
      @strategy = [ OriginalStrategy, NearestVerticalStrategy, NearestHorizontalStrategy ].sample.new
    else
      @strategy = RandomStrategy.new
      @@random = true
    end
    p @strategy.class
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

    module_function :candidates
  end

  class RandomStrategy
    def next_direction(chaser_positions, escapee_positions)
      [ R, L, U, D ].sample
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
end
