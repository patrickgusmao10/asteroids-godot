extends Node

var selected_ship := -1
var high_scores: Array[int] = []
var highest_wave := 1

const SAVE_PATH := "user://high_scores.save"

func _ready():
	load_high_scores()

func add_high_score(new_score: int):
	high_scores.append(new_score)
	high_scores.sort()
	high_scores.reverse()

	if high_scores.size() > 5:
		high_scores.resize(5)

	save_high_scores()

func update_highest_wave(new_wave: int):
	if new_wave > highest_wave:
		highest_wave = new_wave
		save_high_scores()

func save_high_scores():
	var save_data = {
		"high_scores": high_scores,
		"highest_wave": highest_wave
	}

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(save_data)
	file.close()

func load_high_scores():
	if !FileAccess.file_exists(SAVE_PATH):
		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var saved_data = file.get_var()
	file.close()

	if saved_data is Dictionary:
		high_scores.clear()

		var saved_scores = saved_data.get("high_scores", [])

		for saved_score in saved_scores:
			high_scores.append(int(saved_score))

		highest_wave = int(saved_data.get("highest_wave", 1))

	elif saved_data is Array:
		high_scores.clear()

		for saved_score in saved_data:
			high_scores.append(int(saved_score))

		highest_wave = 1

		save_high_scores()
