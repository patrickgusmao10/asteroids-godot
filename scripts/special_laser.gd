extends Area2D

@export var speed := 650.0

var movement_vector := Vector2(0, -1)

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	var material = sprite.material.duplicate() as ShaderMaterial
	sprite.material = material
	
	match GameData.selected_ship:
		0:
			sprite.flip_h = true
			sprite.play("special_green")
			material.set_shader_parameter(
				"target_color",
				Color(0.2, 1.0, 0.35, 1.0)
			)
		1:
			sprite.flip_h = false
			sprite.play("special_blue")
			material.set_shader_parameter(
				"target_color",
				Color(0.15, 0.65, 1.0, 1.0)
			)
		2:
			sprite.flip_h = false
			sprite.play("special_orange")
			material.set_shader_parameter(
				"target_color",
				Color(1.0, 0.45, 0.05, 1.0)
			)
		3:
			sprite.flip_h = false
			sprite.play("special_red")
			material.set_shader_parameter(
				"target_color",
				Color(1.0, 0.15, 0.15, 1.0)
			)

func _physics_process(delta):
	global_position += movement_vector.rotated(rotation) * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_entered(area):
	if area is Asteroid:
		var asteroid = area
		asteroid.explode()
		queue_free()
	elif area.has_method("take_damage"):
		area.take_damage()
		queue_free()
