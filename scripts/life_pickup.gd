extends Area2D

signal collected

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var pickup_sound: AudioStreamPlayer2D = $PickupSound

var collecting := false

func _on_body_entered(body: Node2D) -> void:
	if body is Player and !collecting:
		collected.emit()

func collect() -> void:
	if collecting:
		return

	collecting = true
	sprite.visible = false
	collision.set_deferred("disabled", true)

	pickup_sound.play()
	await pickup_sound.finished

	queue_free()
