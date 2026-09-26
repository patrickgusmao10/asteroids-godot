extends Area2D

signal defeated

enum UFOColor {
	BLUE,
	GREEN,
	RED,
	YELLOW
}

var ufo_textures = [
	preload("res://assets/textures/ufoBlue.png"),
	preload("res://assets/textures/ufoGreen.png"),
	preload("res://assets/textures/ufoRed.png"),
	preload("res://assets/textures/ufoYellow.png")
]

@export var move_speed: float = 170.0
@export var direction_change_min: float = 0.7
@export var direction_change_max: float = 1.6
@export var screen_margin: float = 45.0

var move_direction := Vector2.ZERO
var direction_timer := 0.0
var destroyed := false

@onready var sprite: Sprite2D = $Sprite2D
@onready var ufo_explosion_scene = preload("res://scenes/ufo_explosion.tscn")

func _ready():
	choose_new_direction()


func _physics_process(delta):
	direction_timer -= delta

	if direction_timer <= 0.0:
		choose_new_direction()

	global_position += move_direction * move_speed * delta

	var screen_size = get_viewport_rect().size

	if global_position.x < screen_margin:
		global_position.x = screen_margin
		move_direction.x = abs(move_direction.x)

	elif global_position.x > screen_size.x - screen_margin:
		global_position.x = screen_size.x - screen_margin
		move_direction.x = -abs(move_direction.x)

	if global_position.y < screen_margin:
		global_position.y = screen_margin
		move_direction.y = abs(move_direction.y)

	elif global_position.y > screen_size.y - screen_margin:
		global_position.y = screen_size.y - screen_margin
		move_direction.y = -abs(move_direction.y)


func choose_new_direction():
	move_direction = Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized()

	direction_timer = randf_range(
		direction_change_min,
		direction_change_max
	)


func setup_color(color_index: int):
	sprite.texture = ufo_textures[color_index]


func take_damage():
	destroy_ufo()


func destroy_ufo():
	if destroyed:
		return

	destroyed = true

	var explosion = ufo_explosion_scene.instantiate()
	explosion.global_position = global_position
	get_tree().current_scene.add_child(explosion)

	defeated.emit()
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.name == "Shield":
		var shield_player = area.get_parent()

		if shield_player is Player and shield_player.shield_active:
			destroy_ufo()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.die()
