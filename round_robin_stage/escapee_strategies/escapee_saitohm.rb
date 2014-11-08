require 'pp'

class EscapeeStrategy
  RANGE=5

  def next_direction(chaser_positions, escapee_positions)
    up_count = 0
    down_count = 0
    left_count = 0
    right_count = 0
    up_down_max = 0
    left_right_max = 0

    chaser_positions.each {|dx,dy|
      next if  ( dx.abs > RANGE || dy.abs > RANGE )
      p "dx=#{dx},dy=#{dy}"
      if dx < 0
        up_count += 1
      elsif dx > 0
        down_count += 1
      end
      if dy < 0
        left_count += 1
      elsif dy > 0
        right_count += 1
      end
    }
    p "up=#{up_count},down=#{down_count},left=#{left_count},right=#{right_count}"

    if up_count < down_count
      up_down_max = down_count
    elsif up_count > down_count
      up_down_max = up_count
    else
      up_down_max = 0
    end

    if left_count < right_count
      left_right_max = right_count
    elsif left_count > right_count
      left_right_max = left_count
    else
      left_right_max = 0
    end

    if up_down_max > left_right_max
      return up_count < down_count ? [1,0] : [-1,0]
    elsif up_down_max < left_right_max
      return left_count > right_count ? [0,1] : [0,-1]
    else
      return [1,0]
    end

  end
end
