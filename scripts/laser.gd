extends Area2D

@export var speed := 500.0

var movement_vector := Vector2(0, -1)

@onready var sprite = $Sprite2D

var laser_textures = [
	preload("res://assets/textures/laserGreen11.png"),
	preload("res://assets/textures/laserBlue05.png"),
	preload("res://assets/textures/laserRed16.png"),
	preload("res://assets/textures/laserRed10.png")
]

func _ready():
	sprite.texture = laser_textures[GameData.selected_ship]

func _physics_process(delta):
	global_position += movement_vector.rotated(rotation) * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_entered(area):
	if area is Asteroid:
		var asteroid = area
		asteroid.explode()
		queue_free()
