extends Node

var _all_character_unlockables = [
	CharacterUnlock.new(1, "Reach a minimum score of 1000 in Song 1 in EASY mode")
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
	if song_id == 1 and score >= 1000 and difficulty == Gameplay.Difficulty.EASY and not GameState.unlocked_character_ids.has(1):
			GameState.unlocked_character_ids.push_back(1)
			unlocks.push_back(get_character_unlockable(1))
	#...
	
	return unlocks

func _calculate_percentage(numerator, denominator) -> float:
	var dec_digits = 2
	var num = (numerator*100.0) / denominator
	return round(num * pow(10.0, dec_digits)) / pow(10.0, dec_digits)
	
