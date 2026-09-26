extends Control

@onready var score_labels = [
	$ScoresContainer/Score1,
	$ScoresContainer/Score2,
	$ScoresContainer/Score3,
	$ScoresContainer/Score4,
	$ScoresContainer/Score5
]

func _ready():
	load_high_scores()

func load_high_scores():
	var scores = GameData.high_scores

	for i in range(score_labels.size()):
		if i < scores.size():
			score_labels[i].text = str(i + 1) + ". " + str(scores[i])
		else:
			score_labels[i].text = str(i + 1) + ". 00000"

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
