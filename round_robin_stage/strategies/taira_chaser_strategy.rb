# -*- coding: utf-8 -*-
require 'pp'

class TairaChaserStrategy < ChaserStrategy

  @@leader = nil
  @@target = nil
  @@chaser_positions = nil

  @@top_attacker = nil
  @@bottom_attacker = nil
  @@right_attacker = nil
  @@left_attacker = nil

  def initialize
    if @@leader.nil?
      @@leader = self
    elsif @@top_attacker.nil?
      @@top_attacker = self
    elsif @@bottom_attacker.nil?
      @@bottom_attacker = self
    elsif @@right_attacker.nil?
      @@right_attacker = self
    elsif @@left_attacker.nil?
      @@left_attacker = self
    end
  end

  def leader?
    @@leader == self
  end

  def top_attacker?
    @@top_attacker == self
  end

  def bottom_attacker?
    @@bottom_attacker == self
  end

  def right_attacker?
    @@right_attacker == self
  end

  def left_attacker?
    @@left_attacker == self
  end

  def chase(escapee_positions)
    # ターゲットが移動しているので追跡
    # 移動していない
    target_x, target_y = @@target
    return [target_x, target_y] if escapee_positions.include?([target_x, target_y])

    # 上に逃げた？
    target_x, target_y = @@target
    target_y += 1
    target_y = -24 if target_y > 25
    
    return [target_x, target_y] if escapee_positions.include?([target_x, target_y])

    # 下に逃げた？
    target_x, target_y = @@target
    target_y -= 1
    target_y = 24 if target_y < -25

    return [target_x, target_y] if escapee_positions.include?([target_x, target_y])

    # 左に逃げた？
    target_x, target_y = @@target
    target_x -= 1
    target_x = 24 if target_x < -25

    return [target_x, target_y] if escapee_positions.include?([target_x, target_y])

    # 右に逃げた？
    target_x, target_y = @@target
    target_x += 1
    target_x = -24 if target_x > 25

    return [target_x, target_y] if escapee_positions.include?([target_x, target_y])
  end

  def leader_position(chaser_positions)
    @@chaser_positions.each do |dx, dy|
      chaser_positions.each do |x, y|
        if dx == (x * -1) && dy == (y * -1)
          return [x, y]
        end
      end
      return chaser_positions.first
    end
  end

  def next_direction(chaser_positions, escapee_positions)
    return [0,0] if escapee_positions.empty?

    if leader?
      @@chaser_positions = chaser_positions

      if @@target.nil?
        @@target = escapee_positions.first
      else
        @@target = chase(escapee_positions)
      end

      return [0, 0]
    else

      return [0, 0] if @@target.nil?
      leader_x, leader_y = leader_position(chaser_positions)
      
      target_x, target_y = @@target

      target_x = target_x + leader_x
      target_y = target_y + leader_y

      if target_x > 25
        target_x = -25 + (target_x % 25)
      elsif target_x < -25
        target_x = 25 + (target_x % -25)
      end

      if target_y > 25
        target_y = -25 + (target_y % 25)
      elsif target_y < -25
        target_y = 25 + (target_y % -25)
      end

      next_position = nil
      
      if top_attacker?
        if target_x == 0
          next_position =  [0, -1]
        elsif target_x > 0
          next_position =  [1, 0]
        elsif target_x < 0
          next_position =  [-1, 0]
        end
      elsif bottom_attacker?
        if target_x == 0
          next_position =  [0, 1]
        elsif target_x > 0
          next_position =  [1, 0]
        elsif target_x < 0
          next_position =  [-1, 0]
        end
      elsif right_attacker?
        if target_y == 0
          next_position =  [1, 0]
        elsif target_y > 0
          next_position =  [0, 1]
        elsif target_y < 0
          next_position =  [0, -1]
        end
      elsif left_attacker?
        if target_y == 0
          next_position =  [-1, 0]
        elsif target_y > 0
          next_position =  [0, 1]
        elsif target_y < 0
          next_position =  [0, -1]
        end
      end

      if chaser_positions.include?(next_position)
        return [[0,0], [0,1], [0,-1],[1,0],[-1,0]].sample
      else
        return next_position
      end
    end
  end
end
