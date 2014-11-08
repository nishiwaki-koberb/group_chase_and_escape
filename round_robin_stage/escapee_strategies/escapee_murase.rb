require 'pp'

class EscapeeStrategy
  
  def initialize
  end

  def next_direction(chaser_positions, escapee_positions)
    points = { [1,0] => 0.0, [-1,0] => 0.0, [0,1] => 0.0, [0,-1] => 0.0 }
    d = chaser_positions.first.map {|x| x.abs}.inject(:+)
    if d < 5
      chaser_positions[0..3].each do |dx,dy|
        r = (dx.abs + dy.abs).to_f
        if dx > 0
          points[ [1,0] ] -= dx.abs/(r*r)
        elsif dx < 0
          points[ [-1,0] ] -= dx.abs/(r*r)
        end
        if dy > 0
          points[ [0,1] ] -= dy.abs/(r*r)
        elsif dy < 0
          points[ [0,-1] ] -= dy.abs/(r*r)
        end
      end
      points.max {|a,b| a[1] <=> b[1] }[0]
    else
      escapee_positions[0..3].each do |dx,dy|
        r = (dx.abs + dy.abs).to_f
        if dx > 0
          points[ [-1,0] ] += dx.abs/(r*r)
        elsif dx < 0
          points[ [1,0] ] += dx.abs/(r*r)
        end
        if dy > 0
          points[ [0,-1] ] += dy.abs/(r*r)
        elsif dy < 0
          points[ [0,1] ] += dy.abs/(r*r)
        end
      end
      chaser_positions[0..3].each do |dx,dy|
        r = (dx.abs + dy.abs).to_f
        denom = 1.0/((r-5)*(r-5))
        if dx > 0
          points[ [-1,0] ] += dx.abs*denom
        elsif dx < 0
          points[ [1,0] ] += dx.abs*denom
        end
        if dy > 0
          points[ [0,-1] ] += dy.abs*denom
        elsif dy < 0
          points[ [0,1] ] += dy.abs*denom
        end
      end
      points.max {|a,b| a[1] <=> b[1] }[0]
    end
=begin
      x,y = chaser_positions.first
      if x.abs > y.abs
        x > 0 ? [1,0] : [-1,0]
      else
        y > 0 ? [0,1] : [0,-1]
      end
=end
  end
end
