extends Node2D

var data = []
func _ready():
	$AudioStreamPlayer.stream = load("res://Jetta-I_d-Love-to-Change-the-World-_Matstubs-Remix_.wav")
	data = AudioToWaveform.generate($AudioStreamPlayer.stream)
	$AudioStreamPlayer.play()
	queue_redraw()
	
func _process(delta):
	$Camera2D.position.x += delta*200

func _draw():
	for i in data.size():
		draw_line(Vector2(i*2, 500), Vector2(i*2, 200-data[i]),Color.GREEN,2.0)
	
