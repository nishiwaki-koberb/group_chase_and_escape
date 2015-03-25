class MatsuuraChaserStrategy < ChaserStrategy
    def initialize

    end

    def next_direction(chaser_positions, escapee_positions)
        if escapee_positions.empty?
            return [0,0]
        end
       
        min_node_distance = 2147483648
        closest_chaser = [0,0]
        
        min_distance = 2147483648
        closest_escapee = [0,0]
        
        escapee_positions.each do |escapee|
            tmp_dx, tmp_dy = escapee
            absolute_dx = (tmp_dx > 0) ? tmp_dx : -tmp_dx
            absolute_dy = (tmp_dy > 0) ? tmp_dy : -tmp_dy
            total_distance = absolute_dx + absolute_dy
            if min_distance > total_distance
                min_distance = total_distance
                closest_escapee = [tmp_dx,tmp_dy]
            end
        end

        chaser_positions.each do |chaser|
            escp_dx,escp_dy = closest_escapee
            chsr_dx,chsr_dy = chaser
            absolute_dx = escp_dx - chsr_dx
            absolute_dy = escp_dy - chsr_dy
            total_distance = absolute_dx + absolute_dy
            if min_node_distance > total_distance
                min_node_distance = total_distance
                closest_chaser = chaser
            end
        end

       

        candidate = []

        dx, dy = closest_escapee
        if dx > dy
            if dx > 0
                candidate.push [1,0]
            elsif dx < 0
                candidate.push [-1,0]
            end
        else
            if dy > 0
                candidate.push [0,1]
            elsif dy < 0
                candidate.push [0,-1]
            end

        end

        candidate.push [0,0] if candidate.empty?

        return candidate.sample
    end
end
