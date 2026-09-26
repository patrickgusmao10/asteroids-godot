extends Node2D

@onready var lasers = $Lasers
@onready var player = $Player
@onready var asteroids = $Asteroids
@onready var hud = $UI/HUD
@onready var game_over_screen = $UI/GameOverScreen
@onready var player_spawn_pos = $PlayerSpawnPos
@onready var player_spawn_area = $PlayerSpawnPos/PlayerSpawnArea
@onready var wave_label = $UI/HUD/WaveLabel
@onready var twinkle_stars = $TwinkleStars
@onready var pause_menu = $UI/PauseMenu
@onready var muted_label = $UI/MutedLabel

var asteroid_scene = preload("res://scenes/asteroid.tscn")
var explosion_scene = preload("res://scenes/explosion.tscn")
var mini_boss_1_scene = preload("res://scenes/mini_boss.tscn")
var mini_boss_2_scene = preload("res://scenes/mini_boss_2.tscn")
var mini_boss_3_scene = preload("res://scenes/mini_boss_3.tscn")
var mini_boss_4_scene = preload("res://scenes/mini_boss_4.tscn")
var mini_boss_5_scene = preload("res://scenes/mini_boss_5.tscn")
var life_pickup_scene = preload("res://scenes/life_pickup.tscn")
var ufo_scene = preload("res://scenes/ufo.tscn")
var twinkle_star_scene = preload("res://scenes/twinkle_star.tscn")
var special_pickup_scene = preload("res://scenes/special_pickup.tscn")

var mini_boss_active := false
var life_pickup = null
var special_pickup = null

var score := 0:
	set(value):
		score = value
		hud.score = score
		
var lives: int:
	set(value):
		lives = value
		hud.init_lives(lives)

var wave := 1
var asteroids_per_wave := 4
var starting_new_wave := false
var speed_multiplier := 1.0
var safe_spawn_distance := 250.0

func _ready():
	game_over_screen.visible = false
	pause_menu.visible = false
	wave_label.visible = false
	muted_label.visible = AudioServer.is_bus_mute(AudioServer.get_bus_index("Master"))
	score = 0
	lives = 3

	player.connect("laser_shot", _on_player_laser_shot)
	player.connect("died", _on_player_died)

	player.connect("shield_energy_changed", hud.update_shield)
	hud.update_shield(player.shield_energy)

	player.connect("special_energy_changed", hud.update_special)
	hud.update_special(player.special_energy)

	spawn_twinkle_stars()
	
	spawn_mini_boss()

	for asteroid in asteroids.get_children():
		asteroid.connect("exploded", _on_asteroid_exploded)

func _process(delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

	if asteroids.get_child_count() == 0 and !starting_new_wave:
		start_new_wave()

func _input(event):
	if event.is_action_pressed("mute"):
		var master_bus = AudioServer.get_bus_index("Master")
		var is_muted = !AudioServer.is_bus_mute(master_bus)
		AudioServer.set_bus_mute(master_bus, is_muted)
		muted_label.visible = is_muted

func _on_player_laser_shot(laser):
	$LaserSound.play()
	lasers.add_child(laser)

func _on_asteroid_exploded(pos, size, points, asteroid_type):
	$AsteroidHitSound.play()
	score += points

	match size:
		Asteroid.AsteroidSize.LARGE:
			player.add_special_energy(5.0)
		Asteroid.AsteroidSize.MEDIUM:
			player.add_special_energy(3.0)
		Asteroid.AsteroidSize.SMALL:
			player.add_special_energy(2.0)
		Asteroid.AsteroidSize.TINY:
			player.add_special_energy(1.0)

	if asteroid_type == Asteroid.AsteroidType.BROWN:
		match size:
			Asteroid.AsteroidSize.LARGE:
				for i in range(2):
					spawn_asteroid(pos, Asteroid.AsteroidSize.MEDIUM, asteroid_type)
			Asteroid.AsteroidSize.MEDIUM:
				for i in range(3):
					spawn_asteroid(pos, Asteroid.AsteroidSize.SMALL, asteroid_type)
			Asteroid.AsteroidSize.SMALL:
				for i in range(4):
					spawn_asteroid(pos, Asteroid.AsteroidSize.TINY, asteroid_type)
			Asteroid.AsteroidSize.TINY:
				pass
	else:
		match size:
			Asteroid.AsteroidSize.LARGE:
				for i in range(2):
					spawn_asteroid(pos, Asteroid.AsteroidSize.MEDIUM, asteroid_type)
			Asteroid.AsteroidSize.MEDIUM:
				for i in range(2):
					spawn_asteroid(pos, Asteroid.AsteroidSize.SMALL, asteroid_type)
			Asteroid.AsteroidSize.SMALL:
				pass

func spawn_asteroid(pos, size, asteroid_type = Asteroid.AsteroidType.GREY):
	var a = asteroid_scene.instantiate()
	a.global_position = pos
	a.size = size
	a.asteroid_type = asteroid_type
	a.speed_multiplier = speed_multiplier
	a.connect("exploded", _on_asteroid_exploded)
	asteroids.call_deferred("add_child", a)

func spawn_twinkle_stars():
	for i in range(5):
		var star = twinkle_star_scene.instantiate()

		star.position = Vector2(
			randf_range(60, 1220),
			randf_range(60, 660)
		)

		twinkle_stars.add_child(star)

		var animation_player = star.get_node("AnimationPlayer")
		animation_player.seek(randf_range(0.0, 1.2), true)

func spawn_life_pickup():
	if is_instance_valid(life_pickup):
		life_pickup.queue_free()
		life_pickup = null

	life_pickup = life_pickup_scene.instantiate()

	var pickup_position = Vector2(
		randf_range(60, 1220),
		randf_range(60, 660)
	)

	while pickup_position.distance_to(player.global_position) < safe_spawn_distance:
		pickup_position = Vector2(
			randf_range(60, 1220),
			randf_range(60, 660)
		)

	life_pickup.global_position = pickup_position
	life_pickup.collected.connect(_on_life_pickup_collected)

	add_child(life_pickup)

func remove_life_pickup():
	if is_instance_valid(life_pickup):
		life_pickup.queue_free()
		life_pickup = null

func _on_life_pickup_collected():
	if lives >= 3:
		return

	lives += 1

	if is_instance_valid(life_pickup):
		var pickup = life_pickup
		life_pickup = null
		pickup.collect()

func spawn_special_pickup():
	if is_instance_valid(special_pickup):
		special_pickup.queue_free()
		special_pickup = null

	special_pickup = special_pickup_scene.instantiate()

	var pickup_position = Vector2(
		randf_range(60, 1220),
		randf_range(60, 660)
	)

	while pickup_position.distance_to(player.global_position) < safe_spawn_distance:
		pickup_position = Vector2(
			randf_range(60, 1220),
			randf_range(60, 660)
		)

	special_pickup.global_position = pickup_position
	special_pickup.collected.connect(_on_special_pickup_collected)

	add_child(special_pickup)

func remove_special_pickup():
	if is_instance_valid(special_pickup):
		special_pickup.queue_free()
		special_pickup = null

func _on_special_pickup_collected():
	special_pickup = null

func spawn_ufo():
	var ufo = ufo_scene.instantiate()

	var ufo_position = Vector2(
		randf_range(60, 1220),
		randf_range(60, 660)
	)

	while ufo_position.distance_to(player.global_position) < safe_spawn_distance:
		ufo_position = Vector2(
			randf_range(60, 1220),
			randf_range(60, 660)
		)

	ufo.global_position = ufo_position

	var ufo_appearance = int(wave / 3) - 1
	var color_index = ufo_appearance % 4

	ufo.defeated.connect(_on_ufo_defeated)

	add_child(ufo)
	ufo.setup_color(color_index)

func _on_ufo_defeated():
	score += 500
	player.add_special_energy(10.0)
	
func spawn_mini_boss():
	mini_boss_active = true
	
	var boss_scene
	var boss_cycle = ((wave - 1) % 5) + 1
	
	match boss_cycle:
		1:
			boss_scene = mini_boss_1_scene
		2:
			boss_scene = mini_boss_2_scene
		3:
			boss_scene = mini_boss_3_scene
		4:
			boss_scene = mini_boss_4_scene
		5:
			boss_scene = mini_boss_5_scene
	
	var boss = boss_scene.instantiate()

	boss.global_position = Vector2(640, 120)

	boss.defeated.connect(_on_mini_boss_defeated)

	add_child(boss)

func _on_mini_boss_defeated():
	mini_boss_active = false
	
	var boss_cycle = ((wave - 1) % 5) + 1
	score += boss_cycle * 1000
	
	player.add_special_energy(25.0)

func _on_player_died():
	$PlayerDieSound.play()
	var death_position = player.global_position
	lives -= 1
	player.global_position = player_spawn_pos.global_position

	if lives <= 0:
		var explosion = explosion_scene.instantiate()
		explosion.global_position = death_position
		add_child(explosion)
		
		GameData.add_high_score(score)
		GameData.update_highest_wave(wave)
		
		await get_tree().create_timer(1).timeout
		game_over_screen.update_highest_wave()
		game_over_screen.visible = true
	else:
		await get_tree().create_timer(1).timeout

		var spawn_wait_time := 0.0
		var max_spawn_wait := 2.0

		while !player_spawn_area.is_empty and spawn_wait_time < max_spawn_wait:
			await get_tree().create_timer(0.1).timeout
			spawn_wait_time += 0.1

		player.respawn(player_spawn_pos.global_position)

func start_new_wave():
	starting_new_wave = true

	remove_life_pickup()
	remove_special_pickup()
	
	wave += 1

	wave_label.text = "WAVE " + str(wave)
	wave_label.visible = true
	player.can_shoot = false
	$NextWave.play()

	await get_tree().create_timer(2.0).timeout

	wave_label.visible = false

	spawn_mini_boss()

	if wave >= 2:
		spawn_life_pickup()
		spawn_special_pickup()

	if wave % 3 == 0:
		spawn_ufo()

	player.can_shoot = true
	
	asteroids_per_wave += 1
	speed_multiplier += 0.1
	
	for i in range(asteroids_per_wave):
		var pos = Vector2(
			randf_range(0, 1280),
			randf_range(0, 720)
		)

		while pos.distance_to(player.global_position) < safe_spawn_distance:
			pos = Vector2(
				randf_range(0, 1280),
				randf_range(0, 720)
			)
		
		var random_type = [
			Asteroid.AsteroidType.GREY,
			Asteroid.AsteroidType.BROWN
		].pick_random()

		var random_size

		if wave >= 3:
			random_size = Asteroid.AsteroidSize.LARGE
		else:
			if random_type == Asteroid.AsteroidType.BROWN:
				random_size = [
					Asteroid.AsteroidSize.LARGE,
					Asteroid.AsteroidSize.MEDIUM,
					Asteroid.AsteroidSize.SMALL,
					Asteroid.AsteroidSize.TINY
				].pick_random()
			else:
				random_size = [
					Asteroid.AsteroidSize.LARGE,
					Asteroid.AsteroidSize.MEDIUM,
					Asteroid.AsteroidSize.SMALL
				].pick_random()
		
		spawn_asteroid(pos, random_size, random_type)
	
	starting_new_wave = false
