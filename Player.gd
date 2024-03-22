extends Node2D
const FOLLOW_SPEED = 4.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var mouse_position = get_viewport().get_mouse_position()
	var mouse_position = get_local_mouse_position()
	#position.y = mouse_position.y
	$Sprite2D.position.y = $Sprite2D.position.lerp(mouse_position, delta * FOLLOW_SPEED).y
	
