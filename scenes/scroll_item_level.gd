@tool
extends Panel

@export var song_title: String
@export var song_path: String

func _process(delta):
	$Title.text = song_title

func _on_play_button_pressed():
	get_tree().root.get_node("LevelSelection").on_level_selected(song_path)
