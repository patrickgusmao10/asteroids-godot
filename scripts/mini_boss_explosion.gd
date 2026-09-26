extends AnimatedSprite2D

@onready var explosion_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready():
	explosion_sound.play()
	play("default")
	animation_finished.connect(_on_animation_finished)

func _on_animation_finished():
	queue_free()
