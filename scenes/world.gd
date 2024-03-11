extends Node2D

var data = []
var points_per_second = 50
func _ready():
	$AudioStreamPlayer.stream = load("res://Jetta-I_d-Love-to-Change-the-World-_Matstubs-Remix_.wav")
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
			draw_line(Vector2(576+i*2, 648), Vector2(576+i*2, 600-data[i]), Color.ORANGE,2.0)
			
	for i in range(1,data.size()):
		draw_line(Vector2(576+(i-1)*2, 600-data[i-1]), Vector2(576+i*2, 600-data[i]), Color.WHITE, 2.0)
