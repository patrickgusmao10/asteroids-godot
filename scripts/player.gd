class_name Player extends CharacterBody2D

signal laser_shot(laser)
signal died
signal shield_energy_changed(value)
signal special_energy_changed(value)

@export var acceleration := 10.0
@export var max_sspeed := 350.0
@export var rotation_speed := 255.0
@export var special_duration := 4.0
@export var special_rotation_speed := 720.0
@export var special_slowdown_duration := 0.8

@onready var muzzle = $Muzzle
@onready var sprite = $Sprite2D
@onready var cshape = $CollisionShape2D
@onready var shield = $Shield
@onready var shield_collision = $Shield/ShieldCollision
@onready var shield_on_sound = $ShieldOnSound
@onready var shield_off_sound = $ShieldOffSound
@onready var shield_sprite = $Shield/ShieldSprite

var laser_scene = preload("res://scenes/laser.tscn")
var special_laser_scene = preload("res://scenes/special_laser.tscn")

var ship_textures = [
	preload("res://assets/textures/playerShip1_green.png"),
	preload("res://assets/textures/playerShip2_blue.png"),
	preload("res://assets/textures/playerShip2_orange.png"),
	preload("res://assets/textures/playerShip3_red.png")
]

var shoot_cd = false
var rate_of_fire = 0.11

var special_rate_of_fire := 0.06
var special_shoot_cd := false

var alive := true
var can_shoot := true
var invincible := false

var shield_active := false
var shield_depleted := false
var shield_max_energy := 7.0
var shield_energy := 7.0
var shield_recharge_rate := 1.0

var special_active := false
var special_time_left := 0.0
var special_current_rotation_speed := 0.0
var special_max_energy := 100.0
var special_energy := 0.0

func _ready():
	sprite.texture = ship_textures[GameData.selected_ship]
	shield.visible = false
	shield_collision.set_deferred("disabled", true)

func _process(delta):
	if !alive:
		return

	if Input.is_action_just_pressed("special") and !special_active and !invincible and special_energy >= special_max_energy:
		activate_special()

	if special_active and can_shoot and !invincible:
		if !special_shoot_cd:
			special_shoot_cd = true
			shoot_special_laser()
			reset_special_shoot_cooldown()

	if Input.is_action_pressed("shoot") and can_shoot and !invincible and !special_active:
		if !shoot_cd:
			shoot_cd = true
			shoot_laser()
			await get_tree().create_timer(rate_of_fire).timeout
			shoot_cd = false

func _physics_process(delta):
	if !alive:
		return
	
	if !Input.is_action_pressed("shield"):
		shield_depleted = false
	
	var wants_shield = (
		Input.is_action_pressed("shield")
		and !invincible
		and shield_energy > 0.0
		and !shield_depleted
	)
	
	if wants_shield:
		shield_energy -= delta
		shield_energy = max(shield_energy, 0.0)
		shield_energy_changed.emit(shield_energy)
		
		if !shield_active:
			shield_active = true
			shield_sprite.scale = Vector2.ONE
			shield_sprite.modulate = Color.WHITE
			shield.visible = true
			shield_collision.set_deferred("disabled", false)
			shield_on_sound.play()
		
		if shield_energy <= 0.0:
			shield_depleted = true
			shield_active = false
			shield.visible = false
			shield_collision.set_deferred("disabled", true)
			shield_off_sound.play()
	
	elif shield_active:
		shield_active = false
		shield.visible = false
		shield_collision.set_deferred("disabled", true)
		shield_off_sound.play()

	if !shield_active and shield_energy < shield_max_energy:
		shield_energy += shield_recharge_rate * delta
		shield_energy = min(shield_energy, shield_max_energy)
		shield_energy_changed.emit(shield_energy)
	
	var input_vector := Vector2(0, Input.get_axis("move_forward", "move_backward"))

	velocity += input_vector.rotated(rotation) * acceleration
	velocity = velocity.limit_length(max_sspeed)

	if special_active:
		special_time_left -= delta

		if special_time_left <= special_slowdown_duration:
			var slowdown_factor = clamp(
				special_time_left / special_slowdown_duration,
				0.0,
				1.0
			)

			special_current_rotation_speed = special_rotation_speed * slowdown_factor
		else:
			special_current_rotation_speed = special_rotation_speed

		rotate(deg_to_rad(special_current_rotation_speed * delta))

		if special_time_left <= 0.0:
			special_active = false
			special_time_left = 0.0
			special_current_rotation_speed = 0.0
			special_shoot_cd = false
	else:
		if Input.is_action_pressed("rotate_right"):
			rotate(deg_to_rad(rotation_speed * delta))
		
		if Input.is_action_pressed("rotate_left"):
			rotate(deg_to_rad(-rotation_speed * delta))
	
	if input_vector.y == 0:
		velocity = velocity.move_toward(Vector2.ZERO, 3)
	
	move_and_slide()
	
	var screen_size = Vector2(1280, 720)
	
	if global_position.y < 0:
		global_position.y = screen_size.y
	elif global_position.y > screen_size.y:
		global_position.y = 0
	
	if global_position.x < 0:
		global_position.x = screen_size.x
	elif global_position.x > screen_size.x:
		global_position.x = 0

func add_special_energy(amount: float):
	if special_active:
		return

	special_energy += amount
	special_energy = min(special_energy, special_max_energy)
	special_energy_changed.emit(special_energy)

func activate_special():
	special_energy = 0.0
	special_energy_changed.emit(special_energy)

	special_active = true
	special_time_left = special_duration
	special_current_rotation_speed = special_rotation_speed
	special_shoot_cd = false

func reset_special_shoot_cooldown():
	var current_rate_of_fire = special_rate_of_fire

	if special_active and special_time_left <= special_slowdown_duration:
		var slowdown_factor = clamp(
			special_time_left / special_slowdown_duration,
			0.0,
			1.0
		)

		current_rate_of_fire = lerp(
			0.30,
			special_rate_of_fire,
			slowdown_factor
		)

	await get_tree().create_timer(current_rate_of_fire).timeout
	special_shoot_cd = false

func shoot_laser():
	var l = laser_scene.instantiate()
	l.global_position = muzzle.global_position
	l.rotation = rotation
	emit_signal("laser_shot", l)

func shoot_special_laser():
	var l = special_laser_scene.instantiate()
	l.global_position = muzzle.global_position
	l.rotation = rotation
	emit_signal("laser_shot", l)

func die():
	if alive == true and !invincible and !shield_active:
		alive = false
		special_active = false
		special_time_left = 0.0
		special_current_rotation_speed = 0.0
		special_shoot_cd = false
		shield_active = false
		shield.visible = false
		shield_collision.set_deferred("disabled", true)
		sprite.visible = false
		cshape.set_deferred("disabled", true)
		emit_signal("died")

func respawn(pos):
	if alive == false:
		alive = true
		invincible = true
		special_active = false
		special_time_left = 0.0
		special_current_rotation_speed = 0.0
		special_shoot_cd = false
		shield_active = false
		shield.visible = false
		shield_collision.set_deferred("disabled", true)
		
		global_position = pos
		velocity = Vector2.ZERO
		
		sprite.visible = true
		cshape.set_deferred("disabled", false)
		
		start_invincibility()

func start_invincibility():
	for i in range(6):
		sprite.modulate.a = 0.35
		await get_tree().create_timer(0.25).timeout
		
		sprite.modulate.a = 1.0
		await get_tree().create_timer(0.25).timeout
	
	invincible = false
	sprite.modulate.a = 1.0

func shield_hit_effect():
	if !shield_active:
		return

	shield_sprite.modulate = Color(1.0, 0.2, 0.2, 1.0)

	await get_tree().create_timer(0.20).timeout

	if is_instance_valid(shield_sprite):
		shield_sprite.modulate = Color.WHITE
