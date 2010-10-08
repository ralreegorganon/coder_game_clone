class Level < GameState
  traits :viewport, :timer
  attr_reader :player, :game_object_map
  
  def setup
    self.input = {:escape => :exit, :e => :edit }
    
    self.viewport.game_area = [0,0,1000,300]
    
    @file = File.join(ROOT, "level1.yml")
    load_game_objects(:file => @file)
    
    @grid = [10,10]
    self.viewport.lag = 0.95
    @player = Player.create(:x => 100, :y => 200)
    
    self.viewport.center_around(@player)
        
    @game_object_map = GameObjectMap.new(:game_objects => Block.all + Door.all + Desk.all, :grid => @grid)
  end
  
  def edit
    push_game_state GameStates::Edit.new(:grid => @grid, :except => [Player], :file => @file)
  end
  
  def update
    super
    self.viewport.center_around(@player)
  end
  
  def draw
    fill(Color::WHITE)
    super
  end
end

class Level1 < Level; end