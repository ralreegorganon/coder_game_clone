class Client < GameObject
  trait :bounding_box, :scale => 0.8, :debug => false
  traits :collision_detection, :timer, :velocity
  
  def setup
    @animations = Hash.new
    @animations[:full] = Animation.new(:file => "Client.png", :size => 50)   
    @animations[:running] = @animations[:full][0..2]
    @animations[:jumping] = @animations[:full][3..3] 
    @animations[:standing] = @animations[:full][0..0]
    @animation = @animations[:standing]
    
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
    @animation =  @animations[:running]
  end

  def move_right      
    move(@speed, 0)
    @animation =  @animations[:running]
  end

  def jump
    return if @jumping
    @jumping = true
    self.velocity_y = -10
    @animation = @animations[:jumping]
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
    @image = @animation.next
    self.each_collision(Block) do |me, stone_wall|
      if self.velocity_y < 0  # Hitting the ceiling
        me.y = stone_wall.bb.bottom + me.image.height * self.factor_y
        self.velocity_y = 0
      else  # Land on ground
        @jumping = false        
        me.y = stone_wall.bb.top-1
      end
    end
    
    @animation = @animations[:standing] unless @x != @previous_x or @y != @previous_y
  end
end