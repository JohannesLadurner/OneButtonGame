extends Panel


func _on_resume_button_pressed():
	get_tree().paused = false
	hide()

func _on_back_button_pressed():
	get_tree().paused = false
	FadeTransition.change_scene("res://scenes/song_selection.tscn")
	BackgroundMusic.play()
	
func _on_back_button_mouse_entered():
	$Warning.show()

func _on_back_button_mouse_exited():
	$Warning.hide()
