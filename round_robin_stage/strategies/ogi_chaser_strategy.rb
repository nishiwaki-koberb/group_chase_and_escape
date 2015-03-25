require 'pp'

class OgiChaserStrategy < ChaserStrategy
  @@chaser_count = 0
  @@zenigata_id = [1,2]
  @@zenigata2_id = [3]
  @@step_limit = 50
  @@position_limit = 25

  attr_accessor :id, :from_initial_position, :limit, :step

  def initialize
    @@chaser_count = @@chaser_count + 1
    @id = @@chaser_count
    @from_initial_position = [0,0]
    @step = 0
  end

  def next_direction(chaser_positions, escapee_positions)
    return [0,0] if escapee_positions.empty?
    return closer_position escapee_positions.first if @@zenigata_id.include? @id

    @step = @step + 1
    if @step >= @@step_limit
      @step = 0
      escapee_id = 0
      escapee_id = 1 if escapee_positions.count >= 2
      # return closer_position escapee_positions.sample if @@zenigata2_id.include? @id
      return closer_position escapee_positions.first
    end

    escapee_positions.each do |escapee|
      pos = closer_position escapee

      new_x = @from_initial_position[0] + pos[0]
      if new_x.abs <= @@position_limit + @id
        @from_initial_position[0] = new_x
      else
        next
      end

      new_y = @from_initial_position[1] + pos[1]
      if new_y.abs <= @@position_limit + @id
        @from_initial_position[1] = @from_initial_position[1] + pos[1]
      else
        next
      end

      return pos
    end

    return [0,0]
  end
end

private

def closer_position(escapee)
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
