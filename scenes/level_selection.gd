extends Node2D

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


func _on_file_dialog_file_selected(path):
	#For local export
	var stream = WAVFileReader.load(path).result
	switch_to_level(stream)
	

func switch_to_level(stream: AudioStream):
	Global.selected_stream = stream
	get_tree().change_scene_to_file("res://scenes/world.tscn")
