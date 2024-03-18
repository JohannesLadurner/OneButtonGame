extends Node2D

func _on_button_pressed():
	$FileDialog.popup_centered(Vector2(500,500))


func _on_file_dialog_file_selected(path):
	#For local export
	var stream = WAVFileReader.load(path).result
	
	#For HTML export
	#var reader = JavaScriptFileReader.new()
	#var data = reader.select_file_data()
	#var stream = WAVFileReader.load_from_data(result).result
	
	Global.selected_stream = stream
	get_tree().change_scene_to_file("res://scenes/world.tscn")
