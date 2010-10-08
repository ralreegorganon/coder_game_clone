class Door < GameObject
  trait :bounding_box, :debug => false
  trait :collision_detection
  
  attr_accessor :locked
  
  def setup
    @image = Image["locked_door.png"]
    cache_bounding_box
    @locked = true
  end
  
  def use
    $window.game_state_manager.push_game_state Popup.new(:text => 'You must give the answer in order to pass. Hahahah!')
    return if not @locked
    @locked = false
    @image = Image["unlocked_door.png"]
  end
end