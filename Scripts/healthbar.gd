extends Sprite2D

var health = 100 # Percent
var maxSize

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	maxSize = region_rect.size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	region_rect.size = Vector2((maxSize[0] / 100) * health, maxSize[1])
