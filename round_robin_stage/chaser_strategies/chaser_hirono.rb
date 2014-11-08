require 'pp'

class ChaserStrategy

  R = [ 1, 0].freeze
  L = [-1, 0].freeze
  U = [0, -1].freeze
  D = [0,  1].freeze

  def initialize
    @strategy = [ OriginalStrategy, NearestVerticalStrategy, NearestHorizontalStrategy ].sample.new
  end

  def next_direction(chaser_positions, escapee_positions)
    if escapee_positions.empty?
      [0, 0]
    else
      @strategy.next_direction(chaser_positions, escapee_positions)
    end
  end

  module Nearest
    def candidates(dx, dy)
      candidates = []
      if dx > 0
        candidates.push R
      elsif dx < 0
        candidates.push L
      end
      if dy > 0
        candidates.push D
      elsif dy < 0
        candidates.push U
      end
      candidates
    end
    module_function :candidates
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
