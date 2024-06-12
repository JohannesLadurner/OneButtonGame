extends Node2D
#Idea: Rockets fly through the air, player has to avoid them. Helpful to go against players that only play at one height?

class DataPoint:
	var x: int
	var y: int
	var player_distance: int = -1

var data_points = []
var reward_history = []
var camera_offset = 0
var offset = 750

var pixel_per_second
var music_length
var score
var data_index = 0

var finished = false

func _ready():
	BackgroundMusic.stop()
	$AudioStreamPlayer.stream = GameState.current_stream
	var heights = AudioToWaveform.generate($AudioStreamPlayer.stream, GameState.gameplay_properties.get_samples_per_second(), GameState.gameplay_properties.get_max_height())
	data_points = _generate_data_points(heights)
	reward_history.resize(data_points.size())
	music_length = $AudioStreamPlayer.stream.get_length()
	pixel_per_second = data_points[data_points.size()-1].x/($AudioStreamPlayer.stream.get_length()+offset)
	queue_redraw()
	score = 0
	#$AudioStreamPlayer.play()

func _process(delta):
	if finished: return
	
	if $Camera2D.position.x < offset:
		_update_positions($Camera2D.position.x + 75*delta)
		return
	elif $AudioStreamPlayer.get_playback_position() == 0:
		$AudioStreamPlayer.play()
		
	#Logic for consistent speed
	#$Camera2D.position.x = $AudioStreamPlayer.get_playback_position()*pixel_per_second+offset
	#$Sprite2D.position = $Camera2D.position
	
	#Logic for varying speed based on music intensity. Idea: Progress of music is 75% -> progress of data points must also be 75%
	var music_progress = $AudioStreamPlayer.get_playback_position()/music_length #Calculate current progress of the music
	data_index = ceil(data_points.size() * music_progress) #Apply that progress to the data points
	
	if data_index >= data_points.size(): #Reached end of song
		GameState.current_rewards = reward_history
		FadeTransition.change_scene("res://scenes/results.tscn", 0.5)
		finished = true
		return
	
	var pos_x = data_points[data_index].x #Take the x pos from the data point
	_update_positions(pos_x)
	data_points[data_index].player_distance = abs($Player.position.y - data_points[data_index].y)
	var reward = _player_distance_to_reward(data_points[data_index].player_distance)
	if reward != Gameplay.Reward.UNKNOWN and reward_history[data_index] == null: 
		score += reward
		reward_history[data_index] = reward
	updateScore(score)
	$WaveClearedViewportContainer.position.x = pos_x - $WaveClearedViewportContainer.size.x - 5
	$WaveClearedViewportContainer.queue_redraw()
	
func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().paused = true
		$Camera2D/PauseMenu.show()

func _update_positions(position: int):
	$Camera2D.position.x = position + camera_offset
	$Sprite2D.position.x = position
	$Player.position.x = position
	

func _draw():
	var steepness = 0
	for i in range(1,data_points.size()):
		draw_line(Vector2(data_points[i-1].x, data_points[i-1].y), Vector2(data_points[i].x, data_points[i].y), Color.WHITE, 2.0, true)	
		var color
		if i % GameState.gameplay_properties.get_samples_per_second() == 0: color = Color.RED
		else: color = Color.ORANGE
		#draw_line(Vector2(data_points[i].x, 650), Vector2(data_points[i].x, data_points[i].y), color, 2.0)


func _on_wave_cleared_viewport_container_draw():
	var index = data_index
	var offset = $Sprite2D.position.x
	var draw_width = $WaveClearedViewportContainer.size.x+25
	while offset - data_points[index].x < draw_width && index > 0:
		var color
		
		#Use color depending on how near the player got
		var reward = _player_distance_to_reward(data_points[index].player_distance)
		#If there is no data available, take last datapoint as a reference
		if reward == Gameplay.Reward.UNKNOWN and index > 0:
			data_points[index].player_distance = data_points[index-1].player_distance
			reward = _player_distance_to_reward(data_points[index].player_distance)
			if reward != Gameplay.Reward.UNKNOWN:
				score += reward
				reward_history[index] = reward
		match reward:
			Gameplay.Reward.UNKNOWN: color = Color.WHITE #No data available
			Gameplay.Reward.MISS: color = Color.RED
			Gameplay.Reward.GOOD: color = Color.ORANGE
			Gameplay.Reward.PERFECT: color = Color.GREEN
		
		var from = Vector2($WaveClearedViewportContainer.size.x+5-(offset-data_points[index].x), data_points[index].y)
		var to = Vector2($WaveClearedViewportContainer.size.x+5-(offset-data_points[index-1].x), data_points[index-1].y)
		$WaveClearedViewportContainer.draw_line(from, to, color, 3.0, true)
		index = index - 1

func _player_distance_to_reward(player_distance: int) -> Gameplay.Reward:
	if player_distance == -1: #No data available
		return Gameplay.Reward.UNKNOWN
	if player_distance < 50:
		return Gameplay.Reward.PERFECT
	if player_distance < 100:
		return Gameplay.Reward.GOOD
	return Gameplay.Reward.MISS
	

func _generate_data_points(heights: Array):
	var x = offset
	var data_points = []
	for i in heights.size():
		#Logic for consistent speed
		#var data_point = DataPoint.new()
		#data_point.x = i
		#data_point.y = 600-heights[i]
		#data_points.push_back(data_point)
	
		#Logic for varying speed
		var speed_range = GameState.gameplay_properties.get_speed_range()
		var distance = round(remap(heights[i], 0, GameState.gameplay_properties.get_max_height(), speed_range.min(), speed_range.max())) #Map the value to a range from 1-5 -> The higher the value, the higher the distance to the next point, camera has to keep up the speed and goes faster
		x += distance
		var data_point = DataPoint.new()
		data_point.x = x
		data_point.y = 600-heights[i]
		data_points.push_back(data_point)
	return data_points

func updateScore(score):
	var txt = "Score: %s" %score
	$Camera2D/Label.text = txt
