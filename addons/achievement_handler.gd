extends Node

var _all_character_unlockables = [
	CharacterUnlock.new(1, "Reach a minimum score of 10000 in Tera - Xomu in EASY mode"),
	CharacterUnlock.new(2, "Reach a minimum score of 15000 in Isotope - Dj Jart in HARD mode")
]

func get_character_unlockable(character_id: int):
	for unlockable in _all_character_unlockables:
		if unlockable.get_character_id() == character_id:
			return unlockable
	return null

class CharacterUnlock:
	var _character_id: int
	var _description: String
	
	func get_character_id() -> int: return _character_id
	func get_description() -> String: return _description
	
	func _init(character_id: int, description: String):
		self._character_id = character_id
		self._description = description

func calculate_total_score() -> int:
	var score = 0
	for reward in GameState.current_rewards:
		score += reward
	return score

func calculate_percentage_of_reward_type(reward_type: Gameplay.Reward) -> float:
	var count = 0
	for reward in GameState.current_rewards:
		if reward == reward_type: count += 1
	return _calculate_percentage(count, GameState.current_rewards.size())
	
func update_achievements() -> Array:
	var unlocks = []
	
	var song_id = GameState.current_song_id
	var difficulty = GameState.gameplay_properties.get_difficulty()
	var score = calculate_total_score()
		
	#Unlock Character with id 1
	if song_id == 0 and score >= 10000 and difficulty == Gameplay.Difficulty.EASY:
			var unlock = _unlock_character(1)
			if unlock != null: unlocks.push_back(unlock)
	#Unlock Character with id 2
	if song_id == 2 and score >= 15000 and difficulty == Gameplay.Difficulty.HARD:
			var unlock = _unlock_character(2)
			if unlock != null: unlocks.push_back(unlock)
	#...
	
	return unlocks

func _unlock_character(id: int) -> CharacterUnlock:
	if not GameState.unlocked_character_ids.has(id):
		GameState.unlocked_character_ids.push_back(id)
		return get_character_unlockable(id)
	return null

func _calculate_percentage(numerator, denominator) -> float:
	var dec_digits = 2
	var num = (numerator*100.0) / denominator
	return round(num * pow(10.0, dec_digits)) / pow(10.0, dec_digits)
	
