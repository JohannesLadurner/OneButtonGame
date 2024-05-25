extends Node

var _all_characters = [
	Character.new(0, load("res://icon.svg"), "Commander"),
	Character.new(1, load("res://assets/characters/alien.png"), "Alien")
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
	var _texture: Texture2D
	var _name: String
	
	func get_texture() -> Texture2D: return _texture
	func get_name() -> String: return _name
	func get_id() -> int: return _id
	
	func _init(id: int, texture: Texture2D, name: String):
		self._id = id
		self._texture = texture
		self._name = name
