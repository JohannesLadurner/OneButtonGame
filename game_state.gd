extends Node


#Stuff for transferring data between scenes
var current_song_id: int #If set to -1 it means that it is a custom song
var current_stream: AudioStream
var current_rewards: Array
var gameplay_properties: Gameplay.Properties = Gameplay.Properties.new()

#Stuff to persist
var unlocked_song_ids: Array
var unlocked_character_ids: Array = [0]
var selected_character_id: int
var highscores: Array = []

func _ready():
	highscores.resize(SongHandler.get_all_songs().size())
	for i in highscores.size():
		highscores[i] = SongHighscores.new(i)
		
func get_highscores(song_id) -> SongHighscores:
	for entry in highscores:
		if entry.get_song_id() == song_id:
			return entry
	return null

class SongHighscores:
	var _song_id: int
	var _scores: Array = []
	
	func get_song_id() -> int: return self._song_id
	func get_score(difficulty: Gameplay.Difficulty) -> int: return self._scores[difficulty]
	func set_scores(scores: Array): self._scores = scores 
	
	func _init(song_id: int):
		var difficulty_count = Gameplay.Difficulty.size()
		self._scores.resize(difficulty_count)
		for i in self._scores.size(): self._scores[i] = 0
		self._song_id = song_id
	
	func set_score(score: int, difficulty: Gameplay.Difficulty):
		self._scores[difficulty] = score
