class Popup < GameState
  def initialize(options = {})
    super
    @color = Gosu::Color.new(200,0,0,0)
    @string = options[:text] || "Press ESC to return."
    @text = Text.new(@string, :x => 20, :y => 10, :align => :left, :zorder => Chingu::DEBUG_ZORDER + 1001, :factor => 1, :size => 36)
  end

  def button_up(id)
    pop_game_state(:setup => false) if id == Gosu::KbEscape   # Return the previous game state, dont call setup()
  end
  
  def draw
    previous_game_state.draw          # Draw prev game state
    $window.draw_quad(  0,0,@color,
                        $window.width,0,@color,
                        $window.width,$window.height,@color,
                        0,$window.height,@color, Chingu::DEBUG_ZORDER + 1000)                            
    @text.draw
  end  
end