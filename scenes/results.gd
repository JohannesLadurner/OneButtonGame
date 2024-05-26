extends Node2D

@onready var percentages_node = $Percentages
@onready var perfect_label = $Percentages/PerfectPercentageTitle/PerfectPercentage
@onready var good_label = $Percentages/GoodPercentageTitle/GoodPercentage
@onready var miss_label = $Percentages/MissPercentageTitle/MissPercentage
@onready var score_label = $Score
@onready var back_button = $BackButton

@onready var percentages_position = $PercentagesPosition
@onready var back_button_position = $BackButtonPosition
@onready var score_position = $ScorePosition


func _ready():
	var rewards_total = GameState.current_rewards.size()
	var score_total = 0
	var perfect_count = 0
	var good_count = 0
	var miss_count = 0
	
	for reward in GameState.current_rewards:
		score_total += reward
		if reward == Gameplay.Reward.MISS: miss_count += 1
		elif reward == Gameplay.Reward.GOOD: good_count += 1
		elif reward == Gameplay.Reward.PERFECT: perfect_count += 1
	
	var perfect_percentage = calculate_percentage(perfect_count, rewards_total)
	var good_percentage = calculate_percentage(good_count, rewards_total)
	var miss_percentage = calculate_percentage(miss_count, rewards_total)
	
	nodes_animation(score_total, perfect_percentage, good_percentage, miss_percentage)


func calculate_percentage(numerator, denominator):
	var dec_digits = 2
	var num = (numerator*100.0) / denominator
	return round(num * pow(10.0, dec_digits)) / pow(10.0, dec_digits)

func nodes_animation(score_total, perfect_percentage, good_percentage, miss_percentage):
	var duration = 4
	var fly_in_duration = 1
	#Score flies in
	var score_position_tween = get_tree().create_tween()
	score_position_tween.tween_property(score_label, "position", score_position.position, fly_in_duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	score_position_tween.tween_callback(func():
		#Score counts up
		var score_tween = get_tree().create_tween()
		score_tween.tween_method(func(num): score_label.text = str("Score: ", num), 0, score_total, duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		score_tween.tween_callback(func():
			#Percentages fly in
			var percentages_tween = get_tree().create_tween()
			percentages_tween.tween_property(percentages_node, "position", percentages_position.position, fly_in_duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
			percentages_tween.tween_callback(func():
				#Percentages go up
				get_tree().create_tween().tween_method(func(num): perfect_label.text = str("%.2f" % (num/100.0), "%"), 0, perfect_percentage*100, duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
				get_tree().create_tween().tween_method(func(num): good_label.text = str("%.2f" % (num/100.0), "%"), 0, good_percentage*100, duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
				var miss_tween = get_tree().create_tween()
				miss_tween.tween_method(func(num): miss_label.text = str("%.2f" % (num/100.0), "%"), 0, miss_percentage*100, duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
				miss_tween.tween_callback(func():
					#Back button flies in
					get_tree().create_tween().tween_property(back_button, "position", back_button_position.position, fly_in_duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
					)
				)
			)
		)

func _on_back_button_pressed():
	FadeTransition.change_scene("res://scenes/song_selection.tscn")
