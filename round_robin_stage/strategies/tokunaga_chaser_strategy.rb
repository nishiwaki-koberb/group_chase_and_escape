require 'pp'

class TokunagaChaserStrategy < ChaserStrategy
  def initialize
    @stage_number = 0
    #to store the direction history
    @direction_history=[]
    @chase_history = []
  end

  def next_direction(chaser_positions, escapee_positions)
    @stage_number = @stage_number +1
    candidate = []
    return [0,0] if escapee_positions.empty?
    dx, dy = escapee_positions.first
    chase_length = dx.abs + dy.abs
    r = 5.0 / (dx.abs + dy.abs)
    
    unless @chase_history 
       @chase_history.first > chase_length
       return @direction_history.first
    end

     @chase_history.push(chase_length)
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
    if escapee_positions.size < 3  
        
    end  
    element = candidate.sample

    @direction_history.push(element)
    element
  end
end
