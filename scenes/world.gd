extends Node2D
#Idea: Rockets fly through the air, player has to avoid them. Helpful to go against players that only play at one height?

class DataPoint:
	var x: int
	var y: int
	var distance: int

var data_points = []
var max_height = 500
var camera_offset = 450
var samples_per_second = 100
var pixel_per_second
var music_length

func _ready():
	$AudioStreamPlayer.stream = load("res://Jetta-I_d-Love-to-Change-the-World-_Matstubs-Remix_.wav")
	var heights = AudioToWaveform.generate($AudioStreamPlayer.stream, samples_per_second, max_height)
	data_points = _generate_data_points(heights)
	music_length = $AudioStreamPlayer.stream.get_length()
	pixel_per_second = data_points[data_points.size()-1].x/$AudioStreamPlayer.stream.get_length()
	queue_redraw()
	$AudioStreamPlayer.play()


func _process(delta):
	#Logic for consistent speed
	#$Camera2D.position.x = $AudioStreamPlayer.get_playback_position()*pixel_per_second+offset
	#$Sprite2D.position = $Camera2D.position
	
	#Logic for varying speed based on music intensity. Idea: Progress of music is 75% -> progress of data points must also be 75%
	var music_pos = $AudioStreamPlayer.get_playback_position()/music_length #Calculate current progress of the music
	var data_index = ceil(data_points.size() * music_pos) #Apply that progress to the data points
	var pos_x = data_points[data_index].x #Take the x pos from the data point
	$Camera2D.position.x = pos_x + camera_offset
	$Sprite2D.position.x = pos_x


func _draw():
	for i in range(1,data_points.size()):
		draw_line(Vector2(data_points[i-1].x, data_points[i-1].y), Vector2(data_points[i].x, data_points[i].y), Color.WHITE, 2.0)	
		var color 
		if i % samples_per_second == 0: color = Color.RED
		else: color = Color.ORANGE
		#draw_line(Vector2(offset + data_points[i].x, 650), Vector2(offset + data_points[i].x, data_points[i].y), color, 2.0)


func _generate_data_points(heights: Array):
	var x = 0
	var data_points = []
	for i in heights.size():
		#Logic for consistent speed
		#var data_point = DataPoint.new()
		#data_point.x = i
		#data_point.y = 600-heights[i]
		#data_points.push_back(data_point)
		
		
		#Logic for varying speed
		var distance = round(remap(heights[i], 0, max_height, 1, 5)) #Map the value to a range from 1-5 -> The higher the value, the higher the distance to the next point, camera has to keep up the speed and goes faster
		x += distance
		var data_point = DataPoint.new()
		data_point.x = x
		data_point.y = 600-heights[i]
		data_point.distance = distance
		data_points.push_back(data_point)
	return data_points
