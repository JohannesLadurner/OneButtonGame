extends Panel

var _song: SongHandler.Song
signal selected
	
func set_song(song: SongHandler.Song):
	_song = song
	$Title.text = song.get_title()
	var duration = floor(load(song.get_stream_path()).get_length()) as int
	$Duration.text = str(duration/60, ":", "%.2d" % (duration % 60))
	var score = GameState.get_highscores(song.get_id()).get_score(GameState.gameplay_properties.get_difficulty())
	$Highscore.text = str("Highscore: ", score)

func _on_play_button_pressed():
	selected.emit(_song)
