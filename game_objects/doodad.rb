class Doodad < GameObject
  trait :bounding_box, :debug => false
  trait :collision_detection
end

class Desk < Doodad
  def setup
    @image = Image["desk.png"]
    cache_bounding_box
  end
end

class Wallpaper < Doodad
  def setup
    @image = Image["Wallpaper.png"]
    cache_bounding_box
  end
end
