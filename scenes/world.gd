extends Node2D

var data = []
var points_per_second = 50
func _ready():
	$AudioStreamPlayer.stream = load("res://maldita.wav")
	data = AudioToWaveform.generate($AudioStreamPlayer.stream, points_per_second)
	$AudioStreamPlayer.play()
	queue_redraw()
	
func _process(delta):
	$Camera2D.position.x += delta*(points_per_second*2)

func _draw():
	for i in data.size():
		if i % 50 == 0:
			draw_line(Vector2(576+i*2, 648), Vector2(576+i*2, 600-data[i]), Color.RED,2.0)
		else:
			draw_line(Vector2(576+i*2, 648), Vector2(576+i*2, 600-data[i]), Color.GREEN,2.0)
	
