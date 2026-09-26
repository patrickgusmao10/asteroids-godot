extends Control

@onready var highest_wave_label = $HighestWaveLabel

func _ready():
	update_highest_wave()

func update_highest_wave():
	highest_wave_label.text = "HIGHEST WAVE: " + str(GameData.highest_wave)

func _on_restart_button_pressed():
	get_tree().reload_current_scene()
