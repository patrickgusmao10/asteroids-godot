extends Control

var selected_ship := -1

@onready var selection_arrow = $SelectionArrow
@onready var controls_panel = $ControlsPanel
@onready var cursor_crosshair = preload("res://assets/textures/cursor_crosshair.png")

func _ready():
	controls_panel.visible = false
	Input.set_custom_mouse_cursor(
		cursor_crosshair,
		Input.CURSOR_ARROW,
		Vector2(cursor_crosshair.get_width() / 2.0, cursor_crosshair.get_height() / 2.0)
	)


func _on_ship_1_button_pressed():
	selected_ship = 0
	
	var button = $ShipSelection/Ship1Button
	selection_arrow.global_position = Vector2(
		button.global_position.x + (button.size.x / 2.0) - (selection_arrow.size.x / 2.0) + 3,
		button.global_position.y - 30
	)
	selection_arrow.visible = true


func _on_ship_2_button_pressed():
	selected_ship = 1

	var button = $ShipSelection/Ship2Button
	selection_arrow.global_position = Vector2(
		button.global_position.x + (button.size.x / 2.0) - (selection_arrow.size.x / 2.0) + 3,
		button.global_position.y - 30
	)

	selection_arrow.visible = true


func _on_ship_3_button_pressed():
	selected_ship = 2

	var button = $ShipSelection/Ship3Button
	selection_arrow.global_position = Vector2(
		button.global_position.x + (button.size.x / 2.0) - (selection_arrow.size.x / 2.0) + 3,
		button.global_position.y - 30
	)

	selection_arrow.visible = true


func _on_ship_4_button_pressed():
	selected_ship = 3

	var button = $ShipSelection/Ship4Button
	selection_arrow.global_position = Vector2(
		button.global_position.x + (button.size.x / 2.0) - (selection_arrow.size.x / 2.0) + 3,
		button.global_position.y - 30
	)

	selection_arrow.visible = true


func _on_start_game_button_pressed() -> void:
	if selected_ship == -1:
		return
	GameData.selected_ship = selected_ship
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_high_score_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/high_scores.tscn")


func _on_controls_button_pressed() -> void:
	$Title.visible = false
	$SelectShipLabel.visible = false
	$ShipSelection.visible = false
	$SelectionArrow.visible = false
	$StartGameButton.visible = false
	$HighScoreButton.visible = false
	$ControlsButton.visible = false

	controls_panel.visible = true


func _on_back_button_pressed() -> void:
	controls_panel.visible = false

	$Title.visible = true
	$SelectShipLabel.visible = true
	$ShipSelection.visible = true
	$StartGameButton.visible = true
	$HighScoreButton.visible = true
	$ControlsButton.visible = true

	if selected_ship != -1:
		$SelectionArrow.visible = true
