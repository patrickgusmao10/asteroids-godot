extends Control

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()
		get_viewport().set_input_as_handled()

func toggle_pause():
	var new_pause_state = !get_tree().paused
	get_tree().paused = new_pause_state
	visible = new_pause_state

func _on_resume_button_pressed():
	get_tree().paused = false
	visible = false

func _on_main_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
