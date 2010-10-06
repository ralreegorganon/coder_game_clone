require 'chingu'
include Gosu
include Chingu

class Game < Chingu::Window
  def intialize
    super(1000,700)
  end
  
  def setup
    switch_game_state(PlayState.new)
  end
end

class PlayState < GameState
  traits :viewport, :timer
  
  def setup
    self.input = {:escape => :exit, :e => :edit }
    self.viewport.game_area = [0,0,3500,2000]
    
    @hero = Hero.create(:x => 100, :y => 400)
    
    load_game_objects :except => Hero
  end
  
  def edit
    push_game_state(GameStates::Edit.new(:grid => [32,32], :classes => [Block]))
  end
  
  def update
    super
    self.viewport.center_around(@hero)
  end
end

class Hero < GameObject
  trait :bounding_box
  traits :timer, :velocity, :collision_detection
  
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

class Block < GameObject
  trait :bounding_box, :debug => false
  trait :collision_detection
  
  def self.solid
    all.select { |block| block.alpha == 255 }
  end

  def self.inside_viewport
    all.select { |block| block.game_state.viewport.inside?(block) }
  end

  def setup
    @image = Image["Earth.png"]
    #@color = Color.new(0xff808080)
  end
end

Game.new.show