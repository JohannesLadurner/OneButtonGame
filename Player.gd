extends Node2D
const FOLLOW_SPEED = 6.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_position = get_global_mouse_position()
	var new_height = position.lerp(mouse_position, delta * FOLLOW_SPEED).y
	if new_height >= 0 and new_height <= 648:
		position.y = new_height
