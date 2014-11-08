require 'pp'

class EscapeeStrategy

  def next_direction(chaser_positions, escapee_positions)
    range = 3
    up_count = 0
    down_count = 0
    left_count = 0
    right_count = 0
    up_down_max = 0
    left_right_max = 0

    chaser_positions.each {|dx,dy|
      next if dx.abs > range || dy.abs > range

      if dy == 1
        up_count += 10
      elsif dy == -1
        down_count += 10
      elsif dy < 0
        up_count += 1
      elsif dy > 0
        down_count += 1
      end

      if dx == 1
        left_count += 10
      elsif dx == -1
        right_count += 10
      elsif dx < 0
        right_count += 1
      elsif dx > 0
        left_count += 1
      end
    }

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
      return up_count > down_count ? [0,1] : [0,-1]
    elsif up_down_max < left_right_max
      return right_count > left_count ? [1,0] : [-1,0]
    else
      return [1,0]
    end

  end
end
