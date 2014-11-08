require 'pp'

class ChaserStrategy
  def initialize
    @stage_number = 0
    @direction_history=[]
  end

  def next_direction(chaser_positions, escapee_positions)
    @stage_number = @stage_number +1
    #if @stage_number > 1000
    #  exit
    #end
    candidate = []
    return [0,0] if escapee_positions.empty?
    dx, dy = escapee_positions.first

    r = 5.0 / (dx.abs + dy.abs)

    if rand < r
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
    else
      candidate = [[1,0],[-1,0],[0,1],[0,-1]]
    end

    @direction_history.push(candidate.sample)
    p @direction_history
    
    if escapee_positions.size < 3
       candidate.min 
    else
      candidate.sample
    end
  end
end
