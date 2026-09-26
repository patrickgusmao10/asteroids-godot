extends Area2D

signal defeated

@export var max_health: int = 3
@export var move_speed: float = 120.0
@export var rotation_speed: float = 180.0
@export var follow_distance: float = 180.0
@export var shoot_interval: float = 2.0
@export var laser_speed: float = 350.0

@export var enemy_laser_scene: PackedScene

var health: int
var player: Node2D
var invincible := true

@onready var boss_sprite: Sprite2D = $BossSprite
@onready var shoot_timer: Timer = $ShootTimer
@onready var health_bar: ProgressBar = $HealthBarAnchor/HealthBar
@onready var health_bar_anchor: Node2D = $HealthBarAnchor
@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound
@onready var muzzle: Marker2D = $Muzzle
@onready var mini_boss_explosion_scene = preload("res://scenes/mini_boss_explosion.tscn")

func _ready():
	health = max_health
	health_bar.max_value = max_health
	health_bar.value = health
	shoot_timer.wait_time = shoot_interval
	shoot_timer.start()
	player = get_tree().get_first_node_in_group("player")
	start_invincibility()

func _physics_process(delta):
	if player == null:
		return

	var direction_to_player = global_position.direction_to(player.global_position)
	var distance_to_player = global_position.distance_to(player.global_position)

	var target_rotation = direction_to_player.angle() - PI / 2.0

	rotation = rotate_toward(
		rotation,
		target_rotation,
		deg_to_rad(rotation_speed) * delta
	)

	health_bar_anchor.global_rotation = 0

	if distance_to_player > follow_distance:
		global_position = global_position.move_toward(
			player.global_position,
			move_speed * delta
		)

func take_damage():
	if invincible:
		return

	health -= 1
	health_bar.value = health

	boss_sprite.modulate = Color.RED
	await get_tree().create_timer(0.12).timeout
	boss_sprite.modulate = Color.WHITE

	if health <= 0:
		var explosion = mini_boss_explosion_scene.instantiate()
		explosion.global_position = global_position
		get_tree().current_scene.add_child(explosion)

		defeated.emit()
		queue_free()

func start_invincibility():
	for i in range(2):
		boss_sprite.modulate.a = 0.35
		await get_tree().create_timer(0.25).timeout

		boss_sprite.modulate.a = 1.0
		await get_tree().create_timer(0.25).timeout

	invincible = false
	boss_sprite.modulate.a = 1.0
	shoot_timer.stop()
	_on_shoot_timer_timeout()
	shoot_timer.start()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.die()

func _on_area_entered(area: Area2D) -> void:
	if area.name == "Shield":
		var shield_player = area.get_parent()

		if shield_player is Player and shield_player.shield_active:
			take_damage()

func _on_shoot_timer_timeout() -> void:
	if player == null:
		return

	if not player.alive:
		return

	var laser = enemy_laser_scene.instantiate()
	var shoot_direction = muzzle.global_position.direction_to(player.global_position)

	laser.global_position = muzzle.global_position
	laser.setup(shoot_direction, laser_speed)

	get_tree().current_scene.add_child(laser)
	shoot_sound.play()
