# ☄️ Asteroids — Godot 4

A recreation of the classic **Asteroids** arcade experience, built from scratch using **Godot 4** and **GDScript**.

This project was developed as a hands-on game development study, focusing on 2D movement, physics, collision detection, shooting mechanics, asteroid spawning, UI, scoring, lives, and game state management.

> 🎮 Recreated from scratch while following **How To Make Asteroids in Godot 4 (Complete Tutorial)**.

---

## 🎮 Play the Game

🌐 **Web version coming soon!**

The game will be available directly in the browser through GitHub Pages.

---

## 🚀 About the Project

The goal of this project was to recreate an Asteroids-style arcade game while learning and practicing the fundamentals of game development with Godot.

Instead of importing a finished project, the game was recreated step by step from an empty Godot project, implementing the scenes, scripts, resources, physics and gameplay systems throughout the development process.

The project includes concepts such as:

- 🚀 Player movement and rotation
- 🔫 Laser shooting
- ☄️ Asteroid spawning and destruction
- 💥 Collision detection
- ❤️ Player lives
- 🏆 Score system
- 🎮 Game over system
- 🔄 Player respawning
- 🌌 2D space environment
- 🔊 Game audio and sound effects

---

## 🛠️ Built With

- **Godot Engine 4**
- **GDScript**
- **Godot 2D Physics**
- **Git & GitHub**

---

## 🧩 Game Architecture

The project follows Godot's scene-based architecture, separating the main gameplay systems into independent scenes and scripts.

The game uses **signals, scene instantiation, collision detection, physics processing and state management** to connect the player, lasers, asteroids, HUD and game flow.

### 🚀 Player Controller — `player.gd`

The player controller handles spaceship movement, acceleration, rotation and screen wrapping.

```gdscript
velocity += input_vector.rotated(rotation) * acceleration
velocity = velocity.limit_length(max_speed)

if Input.is_action_pressed("rotate_right"):
    rotate(deg_to_rad(rotation_speed * delta))

if Input.is_action_pressed("rotate_left"):
    rotate(deg_to_rad(-rotation_speed * delta))

if input_vector.y == 0:
    velocity = velocity.move_toward(Vector2.ZERO, 3)

move_and_slide()
```

The spaceship can also fire lasers by instantiating a laser scene and emitting a signal to the game manager.

```gdscript
func shoot_laser():
    var l = laser_scene.instantiate()
    l.global_position = muzzle.global_position
    l.rotation = rotation
    emit_signal("laser_shot", l)
```

---

### ☄️ Asteroid System — `asteroid.gd`

Asteroids are divided into three different sizes, each with its own speed range, texture, collision shape and score value.

```gdscript
enum AsteroidSize {LARGE, MEDIUM, SMALL}
@export var size := AsteroidSize.LARGE

var points: int:
    get:
        match size:
            AsteroidSize.LARGE:
                return 100
            AsteroidSize.MEDIUM:
                return 50
            AsteroidSize.SMALL:
                return 25
            _:
                return 0
```

When an asteroid is destroyed, it emits its position, size and score value before being removed from the scene.

```gdscript
func explode():
    emit_signal("exploded", global_position, size, points)
    queue_free()
```

---

### 🎮 Game Manager — `game.gd`

The game manager connects the main gameplay systems and controls the overall game state.

At startup, it initializes the score and lives and connects signals from the player and asteroids.

```gdscript
func _ready():
    game_over_screen.visible = false
    score = 0
    lives = 3

    player.connect("laser_shot", _on_player_laser_shot)
    player.connect("died", _on_player_died)

    for asteroid in asteroids.get_children():
        asteroid.connect("exploded", _on_asteroid_exploded)
```

The asteroid destruction system updates the score and creates smaller asteroids from larger ones.

```gdscript
func _on_asteroid_exploded(pos, size, points):
    $AsteroidHitSound.play()
    score += points

    for i in range(2):
        match size:
            Asteroid.AsteroidSize.LARGE:
                spawn_asteroid(pos, Asteroid.AsteroidSize.MEDIUM)
            Asteroid.AsteroidSize.MEDIUM:
                spawn_asteroid(pos, Asteroid.AsteroidSize.SMALL)
            Asteroid.AsteroidSize.SMALL:
                pass
```

The same manager also controls player lives, respawning and the game-over state.

```gdscript
func _on_player_died():
    $PlayerDieSound.play()
    lives -= 1
    player.global_position = player_spawn_pos.global_position

    if lives <= 0:
        await get_tree().create_timer(1).timeout
        game_over_screen.visible = true
    else:
        await get_tree().create_timer(1).timeout

        while !player_spawn_area.is_empty:
            await get_tree().create_timer(0.1).timeout

        player.respawn(player_spawn_pos.global_position)
```

---

### 🔫 Laser System — `laser.gd`

Lasers are implemented as `Area2D` objects and move according to their rotation.

```gdscript
@export var speed := 500.0

var movement_vector := Vector2(0, -1)

func _physics_process(delta):
    global_position += movement_vector.rotated(rotation) * speed * delta
```

When a laser detects an asteroid, it triggers the asteroid's explosion and removes itself.

```gdscript
func _on_area_entered(area):
    if area is Asteroid:
        var asteroid = area
        asteroid.explode()
        queue_free()
```

Lasers are also automatically removed after leaving the visible screen.

```gdscript
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
    queue_free()
```

---

### 🔄 Gameplay Flow

The core gameplay architecture can be summarized as:

```text
Player
  │
  ├── shoots
  ▼
Laser ──────────────► Asteroid
                         │
                         │ exploded signal
                         ▼
                    Game Manager
                    ├── Updates score
                    ├── Spawns smaller asteroids
                    ├── Manages lives
                    ├── Handles respawn
                    └── Controls Game Over

Player ── died signal ──► Game Manager
```

This separation keeps each gameplay component focused on its own responsibility while the **Game Manager** coordinates interactions between the systems.

---

## 📁 Project Structure

```text
asteroids-godot/
├── assets/
│   ├── font/
│   └── textures/
├── resources/
├── scenes/
│   ├── asteroid.tscn
│   ├── game.tscn
│   ├── game_over_screen.tscn
│   ├── hud.tscn
│   ├── laser.tscn
│   ├── player.tscn
│   ├── player_spawn_area.tscn
│   └── ui_life.tscn
├── scripts/
│   ├── asteroid.gd
│   ├── game.gd
│   ├── game_over_screen.gd
│   ├── hud.gd
│   ├── laser.gd
│   ├── player.gd
│   └── player_spawn_area.gd
├── project.godot
├── export_presets.cfg
└── README.md
```

---

## 💻 Running the Project

### Requirements

- Godot Engine 4.x

### Steps

1. Clone the repository:

```bash
git clone https://github.com/patrickgusmao10/asteroids-godot.git
```

2. Open **Godot Engine**.

3. Select **Import**.

4. Navigate to the cloned repository.

5. Select:

```text
project.godot
```

6. Open the project and press **F6/F5** to run the game.

---

## 🎓 Learning Reference

This project was recreated from scratch while following the tutorial:

**How To Make Asteroids in Godot 4 (Complete Tutorial)**  
**Kaan Alpar**

https://www.youtube.com/watch?v=FmIo8iBV1W8

The tutorial was used as a learning resource and reference throughout the development of the project.

---

## 🎯 What I Practiced

Through this project, I practiced:

- Scene-based architecture in Godot
- GDScript programming
- 2D physics
- Player input handling
- Collision detection
- Scene instantiation
- Signals
- UI development
- Game state management
- Resource organization
- Web export with Godot
- Git version control

---

## 🚀 Future Improvements

Some ideas for future versions:

- 🛸 Multiple selectable spaceships
- 🌠 Additional asteroid variations
- 🔊 Expanded sound design
- ✨ Visual effects and particles
- 🏆 Persistent high-score system
- 🎮 Additional gameplay mechanics

---

## 👨‍💻 Author

**Patrick Gusmão**

Software Engineering student and developer exploring game development with Godot.

GitHub: **patrickgusmao10**

---

## ⭐ About This Repository

This repository documents my learning process with **Godot 4** and game development.

If you enjoyed the project, feel free to explore the source code and follow its future improvements.

☄️ **Destroy the asteroids. Survive. Beat your high score.**