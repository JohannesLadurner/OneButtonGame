extends Node

var selected_stream: AudioStream
enum GameplayDifficulty {EASY, MEDIUM, HARD}

var gameplay_properties: GameplayProperties = GameplayProperties.new()

class GameplayProperties:
	var _difficulty: GameplayDifficulty
	var _max_height: int
	var _speed_range: Array
	var _samples_per_second: int
	
	func get_difficulty() -> GameplayDifficulty: return self._difficulty
	func get_max_height() -> int: return self._max_height
	func get_speed_range() -> Array: return self._speed_range
	func get_samples_per_second() -> int: return self._samples_per_second
	
	func _init():
		set_difficulty(GameplayDifficulty.EASY)
	
	func set_difficulty(difficulty: GameplayDifficulty):
		match difficulty:
			GameplayDifficulty.EASY:
				self._max_height = 250
				self._speed_range = range(1, 5)
				self._samples_per_second = 30
			GameplayDifficulty.MEDIUM:
				self._max_height = 350
				self._speed_range = range(2, 10)
				self._samples_per_second = 30
			GameplayDifficulty.HARD:
				self._max_height = 500
				self._speed_range = range(5, 15)
				self._samples_per_second = 30
				
