extends Node2D

@onready var lasers = $Lasers
@onready var player = $Player
@onready var asteroids = $Asteroids
@onready var hud = $UI/HUD
@onready var game_over_screen = $UI/GameOverScreen
@onready var player_spawn_pos = $PlayerSpawnPos
@onready var player_spawn_area = $PlayerSpawnPos/PlayerSpawnArea
@onready var wave_label = $UI/HUD/WaveLabel

var asteroid_scene = preload("res://scenes/asteroid.tscn")
var explosion_scene = preload("res://scenes/explosion.tscn")

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
	wave_label.visible = false
	score = 0
	lives = 3
	player.connect("laser_shot", _on_player_laser_shot)
	player.connect("died", _on_player_died)

	for asteroid in asteroids.get_children():
		asteroid.connect("exploded", _on_asteroid_exploded)

func _process(delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

	if asteroids.get_child_count() == 0 and !starting_new_wave:
		start_new_wave()

func _on_player_laser_shot(laser):
	$LaserSound.play()
	lasers.add_child(laser)

func _on_asteroid_exploded(pos, size, points, asteroid_type):
	$AsteroidHitSound.play()
	score += points

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

func _on_player_died():
	$PlayerDieSound.play()
	var death_position = player.global_position
	lives -= 1
	player.global_position = player_spawn_pos.global_position

	if lives <= 0:
		var explosion = explosion_scene.instantiate()
		explosion.global_position = death_position
		add_child(explosion)
		
		await get_tree().create_timer(1).timeout
		game_over_screen.visible = true
	else:
		await get_tree().create_timer(1).timeout

		while !player_spawn_area.is_empty:
			await get_tree().create_timer(0.1).timeout

		player.respawn(player_spawn_pos.global_position)

func start_new_wave():
	starting_new_wave = true
	
	wave += 1
	wave_label.text = "WAVE " + str(wave)
	wave_label.visible = true
	$NextWave.play()
	
	await get_tree().create_timer(2.0).timeout
	
	wave_label.visible = false
	
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
