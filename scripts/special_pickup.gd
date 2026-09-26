extends Area2D

signal collected

var collected_already := false

@onready var pickup_sound = $AudioStreamPlayer2D

func collect():
	if collected_already:
		return

	collected_already = true

	$Sprite2D.visible = false
	$CollisionShape2D.set_deferred("disabled", true)

	pickup_sound.play()

	await pickup_sound.finished

	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.special_active:
			return

		if body.special_energy >= body.special_max_energy:
			return

		body.add_special_energy(
			body.special_max_energy - body.special_energy
		)

		collected.emit()
		collect()
