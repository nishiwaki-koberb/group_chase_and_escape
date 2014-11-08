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
    @strategy.next_direction(chaser_positions, escapee_positions)
  end

  class Nearest
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
  end

  class OriginalStrategy < Nearest
    def next_direction(chaser_positions, escapee_positions)
      return [0,0] if escapee_positions.empty?
      candidates(*escapee_positions.first).sample
    end
  end

  class NearestVerticalStrategy < Nearest
    def next_direction(chaser_positions, escapee_positions)
      return [0,0] if escapee_positions.empty?
      candidates(*escapee_positions.first).last
    end
  end

  class NearestHorizontalStrategy < Nearest
    def next_direction(chaser_positions, escapee_positions)
      return [0,0] if escapee_positions.empty?
      candidates(*escapee_positions.first).first
    end
  end
end
