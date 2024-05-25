extends Panel

var _song: SongHandler.Song
signal selected
	
func set_song(song: SongHandler.Song):
	_song = song
	$Title.text = song.get_title()

func _on_play_button_pressed():
	selected.emit(_song)
