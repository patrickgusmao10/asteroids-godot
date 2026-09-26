class_name Asteroid extends Area2D

signal exploded(pos, size, points, asteroid_type)

var movement_vector := Vector2(0, -1)

enum AsteroidSize {LARGE, MEDIUM, SMALL, TINY}
@export var size := AsteroidSize.LARGE

enum AsteroidType {GREY, BROWN}
@export var asteroid_type := AsteroidType.GREY

var speed := 50
var speed_multiplier := 1.0
var normal_speed := 50.0
var shield_boost_active := false

@onready var sprite = $Sprite2D
@onready var cshape = $CollisionShape2D

var points: int:
	get:
		match size:
			AsteroidSize.LARGE:
				return 100
			AsteroidSize.MEDIUM:
				return 50
			AsteroidSize.SMALL:
				return 25
			AsteroidSize.TINY:
				return 10
			_:
				return 0

func _ready():
	rotation = randf_range(0, 2 * PI)

	match size:
		AsteroidSize.LARGE:
			speed = randf_range(50, 100)
			if asteroid_type == AsteroidType.BROWN:
				if randi() % 2 == 0:
					sprite.texture = preload("res://assets/textures/meteorBrown_big2.png")
					cshape.set_deferred("shape", preload("res://resources/asteroid_cshape_brown_large.tres"))
				else:
					sprite.texture = preload("res://assets/textures/meteorBrown_big4.png")
					cshape.set_deferred("shape", preload("res://resources/asteroid_cshape_large.tres"))
			else:
				sprite.texture = preload("res://assets/textures/meteorGrey_big4.png")
				cshape.set_deferred("shape", preload("res://resources/asteroid_cshape_large.tres"))

		AsteroidSize.MEDIUM:
			speed = randf_range(100, 150)
			if asteroid_type == AsteroidType.BROWN:
				sprite.texture = preload("res://assets/textures/meteorBrown_med3.png")
				cshape.set_deferred("shape", preload("res://resources/asteroid_cshape_brown_medium.tres"))
			else:
				sprite.texture = preload("res://assets/textures/meteorGrey_med2.png")
				cshape.set_deferred("shape", preload("res://resources/asteroid_cshape_medium.tres"))

		AsteroidSize.SMALL:
			speed = randf_range(100, 200)
			if asteroid_type == AsteroidType.BROWN:
				sprite.texture = preload("res://assets/textures/meteorBrown_small1.png")
				cshape.set_deferred("shape", preload("res://resources/asteroid_cshape_brown_small.tres"))
			else:
				sprite.texture = preload("res://assets/textures/meteorGrey_tiny1.png")
				cshape.set_deferred("shape", preload("res://resources/asteroid_cshape_small.tres"))

		AsteroidSize.TINY:
			speed = randf_range(150, 250)
			sprite.texture = preload("res://assets/textures/meteorBrown_tiny1.png")
			cshape.set_deferred("shape", preload("res://resources/asteroid_cshape_brown_tiny.tres"))

	speed *= speed_multiplier
	normal_speed = speed

func _physics_process(delta):
	if shield_boost_active:
		speed = move_toward(speed, normal_speed, normal_speed * 0.5 * delta)

		if is_equal_approx(speed, normal_speed):
			speed = normal_speed
			shield_boost_active = false

	global_position += movement_vector.rotated(rotation) * speed * delta

	var radius = cshape.shape.radius
	var screen_size = get_viewport_rect().size

	if (global_position.y + radius) < 0:
		global_position.y = screen_size.y + radius
	elif (global_position.y - radius) > screen_size.y:
		global_position.y = -radius

	if (global_position.x + radius) < 0:
		global_position.x = screen_size.x + radius
	elif (global_position.x - radius) > screen_size.x:
		global_position.x = -radius

func explode():
	emit_signal("exploded", global_position, size, points, asteroid_type)
	queue_free()

func _on_body_entered(body):
	if body is Player:
		var player = body
		player.die()

func _on_area_entered(area: Area2D):
	if area.name == "Shield":
		var player = area.get_parent()

		if player is Player and player.shield_active:
			player.shield_hit_effect()
			var bounce_direction = area.global_position.direction_to(global_position)

			if bounce_direction != Vector2.ZERO:
				rotation = bounce_direction.angle() + PI / 2.0
				speed = normal_speed * 1.35
				shield_boost_active = true

			global_position += bounce_direction * 8.0
