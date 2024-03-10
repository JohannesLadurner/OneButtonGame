extends Node2D

func _ready():
	$AudioStreamPlayer.stream = load("res://Golden Haze - Detious.wav")
	var data = AudioToWaveform.generate($AudioStreamPlayer.stream)
	print("here")
