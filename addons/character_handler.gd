extends Node

var _all_characters = [
	Character.new(0, "res://assets/characters/UFO_orange.png", "UFO Orange"),
	Character.new(1, "res://assets/characters/UFO_lila.png", "UFO Purple"),
	Character.new(2, "res://assets/characters/ROCKET_grey.png", "Rocket")
]

func get_character(id: int) -> Character:
	for character in _all_characters:
		if character.get_id() == id:
			return character
	return null

func get_all_characters() -> Array:
	return _all_characters

class Character:
	var _id: int
	var _texture_path: String
	var _name: String
	
	func get_id() -> int: return _id
	func get_texture_path() -> String: return _texture_path
	func get_name() -> String: return _name
	
	func _init(id: int, texture_path: String, name: String):
		self._id = id
		self._texture_path = texture_path
		self._name = name
