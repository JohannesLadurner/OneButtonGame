extends Node2D

var data = []
func _ready():
	$AudioStreamPlayer.stream = load("res://maldita.wav")
	data = AudioToWaveform.generate($AudioStreamPlayer.stream, 50)
	$AudioStreamPlayer.play()
	queue_redraw()
	
func _process(delta):
	$Camera2D.position.x += delta*100

func _draw():
	for i in data.size():
		draw_line(Vector2(i*2, 500), Vector2(i*2, 300-data[i]), Color.GREEN,2.0)
	
