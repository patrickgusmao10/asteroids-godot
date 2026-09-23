# ☄️ Asteroids — Godot 4

A recreation and expansion of the classic **Asteroids** arcade experience, built from scratch using **Godot 4** and **GDScript**.

The project started as a hands-on game development study focused on recreating the fundamentals of Asteroids and has since evolved into a more complete arcade experience featuring spaceship selection, infinite waves, progressive difficulty, multiple asteroid variations, ship-specific lasers, music, UI systems, scoring, lives and game state management.

> 🎮 Originally recreated from scratch while following [How To Make Asteroids in Godot 4 (Complete Tutorial)](https://www.youtube.com/watch?v=FmIo8iBV1W8), and later expanded with new systems, mechanics and original improvements.

---

## 🎮 Play the Game

### 🚀 Version 2 — Latest

### [▶️ PLAY VERSION 2](https://patrickgusmao10.github.io/asteroids-godot/v2/)

The latest version expands the original Asteroids experience with new gameplay systems, progression and customization.

#### ✨ What's New in Version 2

- 🎮 **Main Menu** — A new starting menu introduces the game before entering the action.
- 🚀 **Spaceship Selection** — Choose between different spaceships before starting a run.
- 🎵 **Menu Music** — The main menu now features its own soundtrack.
- ☄️ **New Asteroids** — Additional asteroid types and visual variations have been added.
- 🌊 **Infinite Wave System** — Survive through endless waves of asteroids.
- ⚡ **Progressive Difficulty** — Asteroids become faster as the waves progress.
- ☄️ **Increasing Asteroid Count** — Each new wave introduces more asteroids to survive.
- 🔫 **Ship-Specific Lasers** — Each spaceship fires its own matching laser style.

---

### 🕹️ Version 1 — Original Release

### [▶️ PLAY VERSION 1](https://patrickgusmao10.github.io/asteroids-godot/v1/)

Play the original version of the project featuring the core Asteroids gameplay that started the development journey.

Both versions run directly in your browser — no installation required.

---

## 🚀 About the Project

The goal of this project is to recreate and expand an Asteroids-style arcade game while learning and practicing game development with Godot.

Instead of importing a finished project, the original game was recreated step by step from an empty Godot project, implementing the scenes, scripts, resources, physics and gameplay systems throughout the development process.

After completing the original version, development continued with **Version 2**, introducing new systems and mechanics beyond the initial recreation.

The project now includes concepts such as:

- 🚀 Player movement and rotation
- 🔫 Laser shooting
- 🚀 Multiple selectable spaceships
- 🔫 Ship-specific laser styles
- ☄️ Multiple asteroid variations
- 💥 Collision detection
- ❤️ Player lives
- 🏆 Score system
- 🌊 Infinite wave progression
- ⚡ Progressive difficulty
- 🎮 Main menu
- 🎵 Menu music
- 🔄 Player respawning
- 🎮 Game over system
- 🌌 2D space environment
- 🔊 Game audio and sound effects

---

## 🛠️ Built With

- **Godot Engine 4**
- **GDScript**
- **Godot 2D Physics**
- **Git & GitHub**
- **GitHub Pages**

---

## 🧩 Game Architecture

The project follows Godot's scene-based architecture, separating the main gameplay systems into independent scenes and scripts.

The game uses **signals, scene instantiation, collision detection, physics processing and state management** to connect the player, lasers, asteroids, HUD, menus and overall game flow.

Version 2 expands the original architecture with additional systems responsible for spaceship selection, game configuration and wave progression.

---

### 🎮 Main Menu

Version 2 introduces a dedicated main menu that acts as the entry point for the game.

The menu allows the player to prepare a run before entering the main gameplay scene and introduces the new spaceship selection system.

It also includes its own background music, separating the menu experience from the main gameplay.

---

### 🚀 Spaceship Selection

Before starting the game, the player can choose between different spaceship designs.

The selected ship is carried into the gameplay session and determines the visual appearance of the player's spaceship.

Each ship also uses a matching laser style, giving the available ships their own visual identity during gameplay.

---

### 🚀 Player Controller — `player.gd`

The player controller handles spaceship movement, acceleration, rotation, shooting and screen wrapping.

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

The spaceship can fire lasers by instantiating the configured laser scene and passing it to the game through signals.

```gdscript
func shoot_laser():
    var l = laser_scene.instantiate()

    l.global_position = muzzle.global_position
    l.rotation = rotation

    emit_signal("laser_shot", l)
```

Version 2 expands this system by allowing different spaceships to use their corresponding laser styles.

---

### ☄️ Asteroid System — `asteroid.gd`

Asteroids are implemented as independent `Area2D` objects responsible for their own movement, rotation, collision and destruction behavior.

Different asteroid sizes determine their score value and gameplay behavior.

Version 2 expands the original asteroid system with additional asteroid variations, increasing the visual variety of each wave.

When an asteroid is destroyed, it emits information about the explosion before being removed from the scene.

```gdscript
func explode():
    emit_signal("exploded", global_position, size, points, asteroid_type)
    queue_free()
```

The Game Manager receives this signal and handles the consequences of the asteroid's destruction.

---

### 🌊 Infinite Wave System

One of the major additions in Version 2 is the **infinite wave system**.

Instead of maintaining a fixed asteroid encounter, the game now progresses through continuously increasing waves.

Each completed wave leads to another wave with greater difficulty.

The progression system increases:

- ☄️ The number of asteroids
- ⚡ Asteroid movement speed
- 🌊 The current wave number
- 🎯 Overall survival difficulty

There is no predefined final wave — the objective is to survive for as long as possible while the game continuously becomes more difficult.

---

### 🎮 Game Manager — `game.gd`

The Game Manager coordinates the main gameplay systems and controls the overall game state.

Its responsibilities include:

- Starting gameplay
- Managing the current wave
- Spawning asteroids
- Increasing difficulty
- Tracking the score
- Managing player lives
- Handling asteroid destruction
- Handling player death
- Respawning the player
- Detecting game over
- Coordinating gameplay progression

The manager receives signals from the player and asteroids and determines how those events affect the current game session.

When asteroids are destroyed, the Game Manager updates the score and manages the remaining asteroid population.

When all required asteroids from a wave have been cleared, the game advances to the next wave.

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

Lasers are automatically removed after leaving the visible screen.

```gdscript
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
    queue_free()
```

In Version 2, the laser appearance can change according to the spaceship selected by the player.

---

## 🔄 Gameplay Flow

The Version 2 gameplay flow can be summarized as:

```text
Main Menu
    │
    ▼
Spaceship Selection
    │
    ▼
Start Game
    │
    ▼
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
                    ├── Tracks asteroids
                    ├── Manages lives
                    ├── Handles respawn
                    ├── Controls Game Over
                    └── Controls Waves
                              │
                              ▼
                         Wave Cleared
                              │
                              ▼
                         Next Wave
                         ├── More asteroids
                         └── Higher speed
                              │
                              ▼
                           Repeat
```

This separation keeps each gameplay component focused on its own responsibility while the **Game Manager** coordinates interactions between the systems.

---

## 📁 Project Structure

The project is organized around Godot scenes, scripts, resources, game assets and web builds.

```text
asteroids-godot/

├── assets/
│   ├── audio/
│   ├── font/
│   └── textures/
│
├── docs/
│   ├── v1/
│   │   └── Web build — Version 1
│   │
│   └── v2/
│       └── Web build — Version 2
│
├── resources/
│
├── scenes/
│   ├── asteroid.tscn
│   ├── explosion.tscn
│   ├── game.tscn
│   ├── game_over_screen.tscn
│   ├── hud.tscn
│   ├── laser.tscn
│   ├── main_menu.tscn
│   ├── player.tscn
│   └── player_spawn_area.tscn
│
├── scripts/
│   ├── asteroid.gd
│   ├── explosion.gd
│   ├── game.gd
│   ├── game_data.gd
│   ├── game_over_screen.gd
│   ├── hud.gd
│   ├── laser.gd
│   ├── main_menu.gd
│   ├── player.gd
│   └── player_spawn_area.gd
│
├── project.godot
├── export_presets.cfg
└── README.md
```

The `docs` directory contains the browser-playable builds used by GitHub Pages.

- `docs/v1/` preserves the original release.
- `docs/v2/` contains the latest Version 2 release.

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

## 🌐 Web Versions

The repository also contains exported Web builds that can be played directly through GitHub Pages.

### Version 2

[Play Version 2](https://patrickgusmao10.github.io/asteroids-godot/v2/)

### Version 1

[Play Version 1](https://patrickgusmao10.github.io/asteroids-godot/v1/)

This allows the evolution of the project to remain playable instead of replacing the original version whenever a major update is released.

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
- Menu systems
- Game state management
- Persistent game configuration between scenes
- Wave-based gameplay systems
- Progressive difficulty
- Multiple player configurations
- Resource organization
- Audio integration
- Web export with Godot
- Versioned Web builds
- Git version control
- GitHub Pages deployment

---

## 🧭 Development Roadmap

### ✅ Version 1 — Original Release

The first release established the core Asteroids gameplay:

- Player movement
- Laser shooting
- Asteroid destruction
- Score system
- Lives
- Respawning
- Game over
- Sound effects

### ✅ Version 2 — Current Release

Version 2 expands the game with:

- 🎮 Main menu
- 🚀 Spaceship selection
- 🎵 Menu music
- ☄️ New asteroid variations
- 🌊 Infinite waves
- ⚡ Increasing asteroid speed
- ☄️ Increasing asteroid count
- 🔫 Ship-specific lasers

### 🚧 Next Version

Development continues beyond Version 2.

The next planned release will introduce new combat mechanics and additional challenges:

- 👾 **Mini-Boss Battles** — A mini-boss will appear every 5 waves, adding a new combat challenge to the progression system.
- 🛡️ **Shield Power-Up** — A defensive ability that protects the player's spaceship from incoming damage.
- 🚀 **Homing Missile Power-Up** — A guided missile capable of tracking its target automatically.

More gameplay mechanics, balancing improvements and visual enhancements are planned as the project continues to evolve.

---

## 👨‍💻 Author

**Patrick Gusmão**

Software Engineering student and developer exploring game development with Godot.

GitHub: **patrickgusmao10**

---

## ⭐ About This Repository

This repository documents the evolution of my learning process with **Godot 4** and game development.

The project began as a recreation of the classic Asteroids gameplay and continues to evolve through new versions, mechanics and gameplay systems.

Both the original release and the latest version remain available to play, making it possible to follow the project's progression over time.

If you enjoyed the project, feel free to explore the source code and follow its future improvements.

☄️ **Destroy the asteroids. Survive the waves. Beat your high score.**