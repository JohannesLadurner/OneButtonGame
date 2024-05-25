extends Panel

var _character: CharacterHandler.Character
signal selected
	
func set_character(character: CharacterHandler.Character):
	_character = character
	$Sprite2D.texture = load(character.get_texture_path())
	$Label.text = character.get_name()

func _on_button_pressed():
	selected.emit(_character)
