extends Node2D

@onready var character_sprite = $SelectCharacterButton/Character

func _ready():
	var character = GameState.selected_character
	if character == null:
		character = CharacterHandler.get_all_characters()[0]
		GameState.selected_character = character
	character_sprite.texture = load(character.get_texture_path())

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/level_selection.tscn")

func _on_select_character_button_pressed():
	get_tree().change_scene_to_file("res://scenes/character_selection.tscn")
