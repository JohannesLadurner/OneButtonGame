extends Node2D

@onready var achievement_panel = $Achievement
@onready var achievement_character = $Achievement/Character
@onready var achievement_description = $Achievement/Description

@onready var percentages_node = $Percentages
@onready var perfect_label = $Percentages/PerfectPercentageTitle/PerfectPercentage
@onready var good_label = $Percentages/GoodPercentageTitle/GoodPercentage
@onready var miss_label = $Percentages/MissPercentageTitle/MissPercentage
@onready var score_label = $Score
@onready var back_button = $BackButton
@onready var new_highscore_label = $NewHighscore

@onready var achievement_start_position = $Positions/AchievementStartPosition.position
@onready var achievement_end_position = $Positions/AchievementEndPosition.position
@onready var score_position = $Positions/ScorePosition.position
@onready var percentages_position = $Positions/PercentagesPosition.position
@onready var back_button_position = $Positions/BackButtonPosition.position


var score_total
var perfect_percentage
var good_percentage
var miss_percentage
var achievements
var new_highscore = false

func _ready():
	score_total = AchievementHandler.calculate_total_score()
	perfect_percentage = AchievementHandler.calculate_percentage_of_reward_type(Gameplay.Reward.PERFECT)
	good_percentage = AchievementHandler.calculate_percentage_of_reward_type(Gameplay.Reward.GOOD)
	miss_percentage = AchievementHandler.calculate_percentage_of_reward_type(Gameplay.Reward.MISS)
	
	achievements = AchievementHandler.update_achievements()
	if GameState.current_song_id >= 0: #No custom song
		var highscores = GameState.get_highscores(GameState.current_song_id)
		if highscores != null and score_total > highscores.get_score(GameState.gameplay_properties.get_difficulty()):
			highscores.set_score(score_total, GameState.gameplay_properties.get_difficulty())
			new_highscore = true
	nodes_animation()

func nodes_animation():
	var duration = 4
	var fly_in_duration = 1
	#Score flies in
	var score_position_tween = get_tree().create_tween()
	score_position_tween.tween_property(score_label, "position", score_position, fly_in_duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	score_position_tween.tween_callback(func():
		#Score counts up
		var score_tween = get_tree().create_tween()
		score_tween.tween_method(func(num): score_label.text = str("Score: ", num), 0, score_total, duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		score_tween.tween_callback(func():
			if new_highscore:
				new_highscore_label.visible = true
				new_highscore_label.scale = Vector2(3,3)
				get_tree().create_tween().tween_property(new_highscore_label, "scale", Vector2(1,1), 1)
			#Percentages fly in
			var percentages_tween = get_tree().create_tween()
			percentages_tween.tween_property(percentages_node, "position", percentages_position, fly_in_duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
			percentages_tween.tween_callback(func():
				#Percentages go up
				get_tree().create_tween().tween_method(func(num): perfect_label.text = str("%.2f" % (num/100.0), "%"), 0, perfect_percentage*100, duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
				get_tree().create_tween().tween_method(func(num): good_label.text = str("%.2f" % (num/100.0), "%"), 0, good_percentage*100, duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
				var miss_tween = get_tree().create_tween()
				miss_tween.tween_method(func(num): miss_label.text = str("%.2f" % (num/100.0), "%"), 0, miss_percentage*100, duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
				miss_tween.tween_callback(func():
					#Show all the achievements
					show_achievements()
					#Back button flies in
					get_tree().create_tween().tween_property(back_button, "position", back_button_position, fly_in_duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
					)
				)
			)
		)

func show_achievements():
	var fly_duration = 2
	var show_duration = 3

	for a in achievements:
		achievement_description.text = a.get_description()
		var character = CharacterHandler.get_character(a.get_character_id())
		achievement_character.set_character(character)
		
		await get_tree().create_tween().tween_property(achievement_panel, "position", achievement_end_position, fly_duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT).finished		
		await get_tree().create_timer(show_duration).timeout
		await get_tree().create_tween().tween_property(achievement_panel, "position", achievement_start_position, fly_duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT).finished

func _on_back_button_pressed():
	FadeTransition.change_scene("res://scenes/song_selection.tscn")
