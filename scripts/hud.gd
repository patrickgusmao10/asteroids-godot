extends Control

@onready var score = $Score:
	set(value):
		score.text = "SCORE: " + str(value)

@onready var lives = $Lives
@onready var shield_bar = $ShieldBar
@onready var special_bar = $SpecialBar

var uilife_scene = preload("res://scenes/ui_life.tscn")

var life_textures = [
	preload("res://assets/textures/playerLife1_green.png"),
	preload("res://assets/textures/playerLife2_blue.png"),
	preload("res://assets/textures/playerLife2_orange.png"),
	preload("res://assets/textures/playerLife3_red.png")
]

func init_lives(amount):
	for ul in lives.get_children():
		ul.queue_free()

	for i in amount:
		var ul = uilife_scene.instantiate()
		ul.texture = life_textures[GameData.selected_ship]
		lives.add_child(ul)

func update_shield(value):
	shield_bar.value = value
	
func update_special(value):
	special_bar.value = value
