extends Node2D

@onready var grid_container = $ScrollContainer/MarginContainer/GridContainer

func _ready():
	for character in CharacterHandler.get_all_characters():
		var item = load("res://scenes/scroll_character_item.tscn").instantiate()
		grid_container.add_child(item)
		item.set_character(character)
		item.selected.connect(_on_character_selected)

func _on_character_selected(character: CharacterHandler.Character):
	GameState.selected_character = character
	FadeTransition.change_scene("res://scenes/main_menu.tscn")

func _on_button_pressed():
	FadeTransition.change_scene("res://scenes/main_menu.tscn")
