extends Panel

var _character: CharacterHandler.Character
var _unlocked
signal selected
signal shows_info

func set_character(character: CharacterHandler.Character):
	_character = character
	_unlocked = GameState.unlocked_character_ids.has(character.get_id())
	if _unlocked:
		$Sprite2D.texture = load(character.get_texture_path())
	else:
		$Sprite2D.texture = null #Replace with locked icon
		$Button.disabled = true
		$Button.focus_mode = FOCUS_NONE

	$Label.text = character.get_name()

func _on_button_pressed():
	selected.emit(_character)

func _on_button_mouse_entered():
	if _unlocked:
		shows_info.emit("Character unlocked!")
	else:
		var unlock_info = AchievementHandler.get_character_unlockable(_character.get_id())
		if unlock_info != null:
			shows_info.emit(unlock_info.get_description())
		else:
			shows_info.emit("")

func _on_button_mouse_exited():
	shows_info.emit("")
