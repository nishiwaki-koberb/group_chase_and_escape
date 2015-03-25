require 'pp'

module Hirono

  unless defined? R
    R = [ 1, 0].freeze
    L = [-1, 0].freeze
    U = [0, -1].freeze
    D = [0,  1].freeze
    S = [0,  0].freeze
  end

  module Helpers
    def away_x(dx)
      if dx > 0; L
      elsif dx < 0; R
      else nil
      end
    end
    def away_y(dy)
      if dy > 0; U
      elsif dy < 0; D
      else nil
      end
    end
    def for_x(dx)
      if dx > 0; R
      elsif dx < 0; L
      else nil
      end
    end
    def for_y(dy)
      if dy > 0; D
      elsif dy < 0; U
      else nil
      end
    end
    def distance(dx, dy = 0)
      dx, dy = *dx if Array === dx
      Math.sqrt(dx ** 2 + dy ** 2)
    end
    module_function :away_x, :away_y, :for_x, :for_y, :distance
  end
  module Nearest
    include Helpers
    def candidates(dx, dy)
      [ for_x(dx), for_y(dy) ].compact
    end

    module_function :candidates
  end

  class ChaserWrapper
    def self.wrap(clazz)
      new(clazz.new)
    end

    def initialize(impl)
      @impl = impl
    end

    def next_direction(chaser_positions, escapee_positions)
      if escapee_positions.empty?
        S
      else
        @impl.next_direction(chaser_positions, escapee_positions) || S
      end
    end
  end

  class RandomChaser
    def next_direction(chaser_positions, escapee_positions)
      [ S, R, L, U, D, L, D, L ].sample
    end
  end

  class OriginalChaser
    include Nearest
    def next_direction(chaser_positions, escapee_positions)
      candidates(*escapee_positions.first).sample
    end
  end

  # 縦方向に近付くのを優先
  class NearestVerticalChaser
    include Nearest
    def next_direction(chaser_positions, escapee_positions)
      candidates(*escapee_positions.first).last
    end
  end

  # 横方向に近付くのを優先
  class NearestHorizontalChaser
    include Nearest
    def next_direction(chaser_positions, escapee_positions)
      candidates(*escapee_positions.first).first
    end
  end

  class NearestChaser
    include Nearest
    def next_direction(chaser_positions, escapee_positions)
      dx, dy = escapee_positions.first
      cands = candidates(dx, dy)
      addition = dx.abs > dy.abs ? cands.first : cands.last
      cands << addition
      cands.sample
    end
  end

  class Nearest2Chaser < NearestChaser
    def next_direction(chaser_positions, escapee_positions)
      escapee_positions.shift if 1 < escapee_positions.size
      super(chaser_positions, escapee_positions)
    end
  end

  class MixedChaser < NearestChaser
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

  class TrickStar < NearestChaser
    def next_direction(chaser_positions, escapee_positions)
      [ S, L, D, L, D, L, super(chaser_positions, [escapee_positions.last]) ].sample
    end
  end


  class ChaserTeam

    @@leader = nil
    @@trickstar = nil

    def self.leader
      @@leader
    end

    def self.newInstance
      member = if @@trickstar.nil?
          @@trickstar = TrickStar.new
        elsif @@leader.nil?
          @@leader = LeaderStrategy.new
        else
          TriangleStrategy.new
        end
      ChaserWrapper.new(member)
    end

    class LeaderStrategy < Hirono::NearestChaser
      def initialize
        @chasers = Array.new(4, [0, 0])
        @last_move = [0, 0]
      end

      def next_direction(chaser_positions, escapee_positions)
        @chasers = chaser_positions.dup
        @last_move = super
      end

      def find_from(chaser_positions)
        ldx = @last_move[0]
        ldy = @last_move[1]
        candidates = chaser_positions.select { |cdx, cdy| @chasers.any? { |dx, dy| (cdx - ldx) == -dx && (cdy - ldy) == -dy } }
        if 1 < candidates.length
          candidates2 = candidates.select { |cdx, cdy| chaser_positions.map { |dx, dy| [ -cdx + dx, -cdy + dy ] }.select { |dx, dy| @chasers.any? { |tdx, tdy| (dx - ldx) == tdx && (dy - ldy) == tdy } } }
          (candidates2.empty? ? candidate : candidates2).first
        else
          candidates.first
        end
      end
    end

    class TriangleStrategy < Hirono::NearestChaser
      def next_direction(chaser_positions, escapee_positions)
        leader = ChaserTeam.leader.find_from(chaser_positions)
        ldx, ldy = leader || [0, 0]
        escapings = escapee_positions.map {|dx, dy| [ ldx + dx, ldy + dy ] }.sort_by { |dxy| distance dxy }
        tdx, tdy = escapings.first
        dx = tdx - ldx
        dy = tdy - ldy
        super(chaser_positions, [[dx, dy]])
      end
    end

  end
end

class HironoChaserStrategy < ChaserStrategy
  def initialize
    @impl = Hirono::ChaserTeam.newInstance
  end
  def next_direction(chaser_positions, escapee_positions)
    @impl.next_direction(chaser_positions, escapee_positions)
  end
end
