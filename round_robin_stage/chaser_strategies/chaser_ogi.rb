require 'pp'

class ChaserStrategy
  @@chaser_count = 0
  ZENIGATA1_ID = [1]
  ZENIGATA2_ID = [2]
  STEP_LIMIT = 10

  attr_accessor :id, :from_initial_position, :limit, :step

  def initialize
    @@chaser_count = @@chaser_count + 1
    @id = @@chaser_count
    @from_initial_position = [0,0]
    @limit = 25
    @step = 0
  end

  def next_direction(chaser_positions, escapee_positions)
    return [0,0] if escapee_positions.empty?
    return escapee_position escapee_positions.first if ZENIGATA1_ID.include? @id
    return escapee_position escapee_positions.first if ZENIGATA2_ID.include? @id

    if step >= STEP_LIMIT
      escapee_id = 0
      escapee_id = 1 if escapee_positions.count >= 2
      return escapee_position escapee_positions[escapee_id]
    end

    escapee_positions.each do |escapee|
      pos = escapee_position escapee

       if escapee_positions.count < 5
       end 
        if (@from_initial_position[0] + pos[0]).abs <= @limit + @id
          @from_initial_position[0] = @from_initial_position[0] + pos[0]
        else
          next
        end

        if (@from_initial_position[1] + pos[1]).abs <= @limit + @id
          @from_initial_position[1] = @from_initial_position[1] + pos[1]
        else
          next
        end

        return pos
      # end

    end

    return [0,0]
  end
end

def escapee_position(escapee)
  dx, dy = escapee
  candidate = []
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

  pos = candidate.sample
end 
