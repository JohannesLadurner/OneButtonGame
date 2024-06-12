extends Node

class_name Gameplay

enum Difficulty {EASY, MEDIUM, HARD}

enum Reward {PERFECT=3, GOOD=1, MISS=0, UNKNOWN=-1}

class Properties:
	var _difficulty: Difficulty
	var _max_height: int
	var _speed_range: Array
	var _samples_per_second: int
	
	func get_difficulty() -> Difficulty: return self._difficulty
	func get_max_height() -> int: return self._max_height
	func get_speed_range() -> Array: return self._speed_range
	func get_samples_per_second() -> int: return self._samples_per_second
	
	func _init():
		set_difficulty(Difficulty.MEDIUM)
	
	func set_difficulty(difficulty: Difficulty):
		self._difficulty = difficulty
		match difficulty:
			Difficulty.EASY:
				self._max_height = 300
				self._speed_range = range(1, 5)
				self._samples_per_second = 25
			Difficulty.MEDIUM:
				self._max_height = 400
				self._speed_range = range(1, 10)
				self._samples_per_second = 30
			Difficulty.HARD:
				self._max_height = 500
				self._speed_range = range(1, 15)
				self._samples_per_second = 35
