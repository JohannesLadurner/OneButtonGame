extends Node2D

@onready var character_sprite = $SelectCharacterButton/Character
var character_rotate_right = true
var character_rotation_speed = 0.4
var character_rotation_degrees = 15

func _ready():
	var character = CharacterHandler.get_character(GameState.selected_character_id)
	if character == null:
		character = CharacterHandler.get_all_characters()[0] #Just pick the first character if none was found
		GameState.selected_character_id = character.get_id()
	character_sprite.texture = load(character.get_texture_path())
	
func _process(delta):
	if character_sprite.rotation_degrees >= character_rotation_degrees:
		character_rotate_right = false
	if character_sprite.rotation_degrees <= -character_rotation_degrees:
		character_rotate_right = true
	if character_rotate_right: character_sprite.rotate(character_rotation_speed*delta)
	else: character_sprite.rotate(-character_rotation_speed*delta)
		

func _on_play_button_pressed():
	FadeTransition.change_scene("res://scenes/song_selection.tscn")

func _on_select_character_button_pressed():
	FadeTransition.change_scene("res://scenes/character_selection.tscn")
