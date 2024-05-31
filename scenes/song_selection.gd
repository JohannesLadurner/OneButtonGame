extends Node2D

@onready var container = $ScrollContainer/MarginContainer/VBoxContainer
@onready var difficulty_label = $DifficultyPanel/Difficulty

func _ready():
	difficulty_label.text = Gameplay.Difficulty.keys()[GameState.gameplay_properties.get_difficulty()]
	for song in SongHandler.get_all_songs():
		var item = load("res://scenes/scroll_item_level.tscn").instantiate()
		container.add_child(item)
		item.set_song(song)
		item.selected.connect(on_level_selected)

func _on_custom_song_button_pressed():
	if OS.get_name() == "Web":
		#For HTML export
		var reader = JavaScriptFileReader.new()
		add_child(reader)
		var data = await reader.select_file_data()
		var stream = WAVFileReader.load_from_data(data).result
		GameState.current_song_id = -1 #Custom song
		switch_to_level(stream)
	else:
		$FileDialog.popup_centered(Vector2(500,500))
	
func on_level_selected(song: SongHandler.Song):
	GameState.current_song_id = song.get_id()
	switch_to_level(load(song.get_stream_path()))


func _on_file_dialog_file_selected(path):
	#For local export
	var stream = WAVFileReader.load(path).result
	GameState.current_song_id = -1 #Custom song
	switch_to_level(stream)
	

func switch_to_level(stream: AudioStream):
	GameState.current_stream = stream
	FadeTransition.change_scene("res://scenes/world.tscn")

func _on_easier_button_pressed():
	var difficulty = GameState.gameplay_properties.get_difficulty()
	_set_difficulty(difficulty - 1)


func _on_harder_button_pressed():
	var difficulty = GameState.gameplay_properties.get_difficulty()
	_set_difficulty(difficulty + 1)

func _set_difficulty(difficulty: Gameplay.Difficulty):
	if difficulty >= 0 and difficulty < Gameplay.Difficulty.size():
		GameState.gameplay_properties.set_difficulty(difficulty)
		difficulty_label.text = Gameplay.Difficulty.keys()[difficulty]

func _on_back_button_pressed():
	FadeTransition.change_scene("res://scenes/main_menu.tscn")



