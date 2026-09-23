extends Control

var selected_ship := 0
@onready var selection_arrow = $SelectionArrow

func _on_ship_1_button_pressed():
	selected_ship = 0
	
	var button = $ShipSelection/Ship1Button
	selection_arrow.global_position = Vector2(
		button.global_position.x + (button.size.x / 2.0) - (selection_arrow.size.x / 2.0),
		button.global_position.y - 30
	)
	selection_arrow.visible = true
	
	print("Nave selecionada: VERDE")

func _on_ship_2_button_pressed():
	selected_ship = 1

	var button = $ShipSelection/Ship2Button
	selection_arrow.global_position = Vector2(
		button.global_position.x + (button.size.x / 2.0) - (selection_arrow.size.x / 2.0),
		button.global_position.y - 30
	)

	selection_arrow.visible = true

	print("Nave selecionada: AZUL")


func _on_ship_3_button_pressed():
	selected_ship = 2

	var button = $ShipSelection/Ship3Button
	selection_arrow.global_position = Vector2(
		button.global_position.x + (button.size.x / 2.0) - (selection_arrow.size.x / 2.0),
		button.global_position.y - 30
	)

	selection_arrow.visible = true

	print("Nave selecionada: LARANJA")


func _on_ship_4_button_pressed():
	selected_ship = 3

	var button = $ShipSelection/Ship4Button
	selection_arrow.global_position = Vector2(
		button.global_position.x + (button.size.x / 2.0) - (selection_arrow.size.x / 2.0),
		button.global_position.y - 30
	)

	selection_arrow.visible = true

	print("Nave selecionada: VERMELHA")


func _on_start_game_button_pressed() -> void:
	GameData.selected_ship = selected_ship
	get_tree().change_scene_to_file("res://scenes/game.tscn")
