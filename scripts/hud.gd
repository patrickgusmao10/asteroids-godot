extends Control

@onready var score = $Score:
	set(value):
		score.text = "SCORE: " + str(value)

var uilife_scene = preload("res://scenes/ui_life.tscn")

var life_textures = [
	preload("res://assets/textures/playerLife1_green.png"),
	preload("res://assets/textures/playerLife2_blue.png"),
	preload("res://assets/textures/playerLife2_orange.png"),
	preload("res://assets/textures/playerLife3_red.png")
]

@onready var lives = $Lives

func init_lives(amount):
	for ul in lives.get_children():
		ul.queue_free()

	for i in amount:
		var ul = uilife_scene.instantiate()
		ul.texture = life_textures[GameData.selected_ship]
		lives.add_child(ul)
