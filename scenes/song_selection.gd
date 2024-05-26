extends Node2D

@onready var container = $ScrollContainer/MarginContainer/VBoxContainer

func _ready():
	for song in SongHandler.get_all_songs():
		var item = load("res://scenes/scroll_item_level.tscn").instantiate()
		container.add_child(item)
		item.set_song(song)
		item.selected.connect(on_level_selected)

func _on_button_pressed():
	if OS.get_name() == "Web":
		#For HTML export
		var reader = JavaScriptFileReader.new()
		add_child(reader)
		var data = await reader.select_file_data()
		var stream = WAVFileReader.load_from_data(data).result
		switch_to_level(stream)
	else:
		$FileDialog.popup_centered(Vector2(500,500))


func on_level_selected(song: SongHandler.Song):
	switch_to_level(load(song.get_stream_path()))


func _on_file_dialog_file_selected(path):
	#For local export
	var stream = WAVFileReader.load(path).result
	switch_to_level(stream)
	

func switch_to_level(stream: AudioStream):
	GameState.current_stream = stream
	get_tree().change_scene_to_file("res://scenes/world.tscn")
