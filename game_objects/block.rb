class Block < GameObject
  trait :bounding_box, :debug => false
  trait :collision_detection
  
  def setup
    @image = Image["Tile.png"]
    cache_bounding_box
  end
end