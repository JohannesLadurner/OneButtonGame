extends CanvasLayer

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

signal transitioned

func _ready():
	color_rect.visible = false

func transition():
	color_rect.visible = true
	animation_player.play("fade_out")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_out":
		transitioned.emit()
		animation_player.play("fade_in")
	elif anim_name == "fade_in":
		color_rect.visible = false
		animation_player.speed_scale = 1.0
		
func change_scene(path: String, speed_scale: float = 1.0):
	animation_player.speed_scale = speed_scale
	transition()
	await transitioned
	get_tree().change_scene_to_file(path)
