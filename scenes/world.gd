extends Node2D
#Idea: Rockets fly through the air, player has to avoid them. Helpful to go against players that only play at one height?

class DataPoint:
	var x: int
	var y: int
	var distance: int

var data_points = []
var max_height = 500
var camera_offset = 0
var samples_per_second = 25
var pixel_per_second
var music_length

var data_index = 0

func _ready():
	$AudioStreamPlayer.stream = Global.selected_stream
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
	data_index = ceil(data_points.size() * music_pos) #Apply that progress to the data points
	var pos_x = data_points[data_index].x #Take the x pos from the data point
	$Camera2D.position.x = pos_x + camera_offset
	$Sprite2D.position.x = pos_x
	$Player.position.x = pos_x
	$WaveClearedViewportContainer.position.x = pos_x - $WaveClearedViewportContainer.size.x - 5
	$WaveClearedViewportContainer.queue_redraw()


func _draw():
	var steepness = 0
	for i in range(1,data_points.size()):
		if data_points[i-1].y > data_points[i].y:
			steepness += data_points[i-1].y - data_points[i].y
		else:
			if steepness > 25:
				draw_circle(Vector2(data_points[i-1].x, data_points[i-1].y), 5, Color.RED)
			steepness = 0
			
		
		draw_line(Vector2(data_points[i-1].x, data_points[i-1].y), Vector2(data_points[i].x, data_points[i].y), Color.WHITE, 2.0, true)	
		var color
		if i % samples_per_second == 0: color = Color.RED
		else: color = Color.ORANGE
		#draw_line(Vector2(data_points[i].x, 650), Vector2(data_points[i].x, data_points[i].y), color, 2.0)


func _on_wave_cleared_viewport_container_draw():
	var index = data_index
	var offset = $Sprite2D.position.x
	var draw_width = $WaveClearedViewportContainer.size.x-300
	while offset - data_points[index].x < draw_width && index > 0:
		var from = Vector2($WaveClearedViewportContainer.size.x+5-(offset-data_points[index].x), data_points[index].y)
		var to = Vector2($WaveClearedViewportContainer.size.x+5-(offset-data_points[index-1].x), data_points[index-1].y)
		$WaveClearedViewportContainer.draw_line(from, to, Color.GREEN, 3.0, true)
		index = index - 1

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
		var distance = round(remap(heights[i], 0, max_height, 2, 10)) #Map the value to a range from 1-5 -> The higher the value, the higher the distance to the next point, camera has to keep up the speed and goes faster
		x += distance
		var data_point = DataPoint.new()
		data_point.x = x
		data_point.y = 600-heights[i]
		data_point.distance = distance
		data_points.push_back(data_point)
	return data_points
