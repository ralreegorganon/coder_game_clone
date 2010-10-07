class Player < GameObject
  trait :bounding_box
  traits :collision_detection, :timer, :velocity
  
  def setup
    self.input = {
      :holding_left => :move_left,
      :holding_right => :move_right,
      :up => :jump
    }
    
    @animations = Animation.new(:file => "CptnRuby.png")    
    
    @speed = 3
    @jumping = false
    
    self.zorder = 300
    self.factor = 1
    self.acceleration_y = 0.5
    self.max_velocity = 10
    self.rotation_center = :bottom_center
        
    update
  end
  
  def move_left
    move(-@speed, 0)
  end

  def move_right
    move(@speed, 0)
  end

  def jump
    return if @jumping
    @jumping = true
    self.velocity_y = -10
  end
  
  def move(x,y)
    self.x += x    
    self.each_collision(Block) do |me, stone_wall|
      self.x = previous_x
      break
    end
    self.y += y
  end
  
  def update 
    @image = @animations.next
    
    self.each_collision(Block) do |me, stone_wall|
      if self.velocity_y < 0  # Hitting the ceiling
        me.y = stone_wall.bb.bottom + me.image.height * self.factor_y
        self.velocity_y = 0
      else  # Land on ground
        @jumping = false        
        me.y = stone_wall.bb.top-1
      end
    end
  end
end