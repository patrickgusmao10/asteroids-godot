extends AnimatedSprite2D

@onready var explosion_sound: AudioStreamPlayer2D = get_node_or_null("AudioStreamPlayer2D")

func _ready():
	animation_finished.connect(_on_animation_finished)

	if explosion_sound:
		explosion_sound.play()

func _on_animation_finished():
	queue_free()
