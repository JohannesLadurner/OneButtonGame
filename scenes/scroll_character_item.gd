extends Panel

var _character_id: int
signal selected
	
func set_character(id: int):
	var character = CharacterHandler.get_character(id)
	if character == null:
		print(str("Character with id ", id, " does not exist!"))
		return
	_character_id = id
	if $Sprite2D == null:
		print("here")
	$Sprite2D.texture = character.get_texture()
	$Label.text = character.get_name()

func _on_button_pressed():
	selected.emit(_character_id)
