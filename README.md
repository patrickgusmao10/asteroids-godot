# ☄️ Asteroids — Godot 4

A recreation and expansion of the classic **Asteroids** arcade experience, built from scratch using **Godot 4** and **GDScript**.

The project started as a hands-on game development study focused on recreating the fundamentals of Asteroids and has evolved into a more complete arcade experience featuring spaceship selection, infinite waves, progressive difficulty, mini-boss battles, UFOs, defensive and offensive abilities, pickups, persistent records, custom UI systems, music, sound effects and multiple playable releases.

> 🎮 Originally recreated from scratch while following [How To Make Asteroids in Godot 4 (Complete Tutorial)](https://www.youtube.com/watch?v=FmIo8iBV1W8), and later expanded with new systems, mechanics and original improvements.

---

## 🎮 Play the Game

### ⚡ Version 3 — Latest

### [▶️ PLAY VERSION 3](https://patrickgusmao10.github.io/asteroids-godot/v3/)

Version 3 is the most complete version of the project, expanding the infinite-wave gameplay with new enemies, abilities, pickups, progression systems and quality-of-life improvements.

#### ✨ What's New in Version 3

- 👾 **Mini-Boss Battles** — Face increasingly challenging mini-bosses throughout the run.
- 🛸 **UFO Enemies** — UFOs periodically appear during waves as additional threats.
- 🛡️ **Energy Shield** — Activate a rechargeable defensive shield capable of protecting the spaceship from incoming threats.
- ⚡ **Special Attack** — Charge a special energy meter and unleash a powerful rapid-fire spinning attack.
- 🔋 **Special Energy System** — Destroy enemies and asteroids to progressively charge the special ability.
- ⚡ **Special Energy Pickups** — Collect energy pickups to instantly recharge the special ability when it is not already full.
- ❤️ **Life Pickups** — Recover lost lives by collecting life pickups during waves.
- 🏆 **Enemy Bonus Scores** — UFOs and mini-bosses award additional score when defeated.
- 📈 **High Score System** — Track the player's best scores.
- 🌊 **Highest Wave Record** — The highest wave reached is stored between runs.
- ⏸️ **Pause Menu** — Pause gameplay and resume or return to the main menu.
- 🔇 **Mute Control** — Toggle game audio during gameplay.
- 🎮 **Controls Screen** — View the complete control scheme directly from the main menu.
- 🎯 **Custom Cursor** — A custom pixel-art cursor complements the game's visual identity.
- ✨ **Visual Polish** — Additional background effects and visual feedback improve the arcade presentation.
- 🔊 **Expanded Audio** — Additional sound effects provide feedback for new gameplay mechanics.

---

### 🚀 Version 2

### [▶️ PLAY VERSION 2](https://patrickgusmao10.github.io/asteroids-godot/v2/)

Version 2 introduced the first major expansion beyond the original recreation.

#### ✨ Version 2 Highlights

- 🎮 **Main Menu**
- 🚀 **Spaceship Selection**
- 🎵 **Menu Music**
- ☄️ **New Asteroid Variations**
- 🌊 **Infinite Wave System**
- ⚡ **Progressive Difficulty**
- ☄️ **Increasing Asteroid Count**
- 🔫 **Ship-Specific Lasers**

---

### 🕹️ Version 1 — Original Release

### [▶️ PLAY VERSION 1](https://patrickgusmao10.github.io/asteroids-godot/v1/)

Play the original version of the project featuring the core Asteroids gameplay that started the development journey.

All three versions run directly in your browser — no installation required.

---

## 🚀 About the Project

The goal of this project is to recreate and expand an Asteroids-style arcade game while learning and practicing game development with Godot.

Instead of importing a finished project, the original game was recreated step by step from an empty Godot project, implementing the scenes, scripts, resources, physics and gameplay systems throughout the development process.

After completing the original version, development continued through multiple releases:

**Version 1** established the core Asteroids gameplay.

**Version 2** expanded the project with spaceship selection, additional asteroid variations, infinite waves, progressive difficulty and ship-specific weapons.

**Version 3** significantly expands the combat and progression systems with mini-bosses, UFOs, shield mechanics, special abilities, pickups, persistent records and additional gameplay polish.

The project now includes concepts such as:

- 🚀 Player movement and rotation
- 🔫 Laser shooting
- 🚀 Multiple selectable spaceships
- 🔫 Ship-specific laser styles
- ☄️ Multiple asteroid variations
- 💥 Collision detection
- ❤️ Player lives
- ❤️ Life pickups
- 🏆 Score system
- 📈 High scores
- 🌊 Highest wave tracking
- 🌊 Infinite wave progression
- ⚡ Progressive difficulty
- 👾 Mini-boss encounters
- 🛸 UFO enemies
- 🛡️ Rechargeable shield
- ⚡ Special attack
- 🔋 Special energy system
- ⚡ Special energy pickups
- 🎮 Main menu
- 🎮 Controls screen
- ⏸️ Pause menu
- 🔇 Audio mute control
- 🎯 Custom cursor
- 🎵 Menu music
- 🔄 Player respawning
- 🎮 Game over system
- 🌌 2D space environment
- 🔊 Game audio and sound effects

---

## 🎮 Controls

| Key | Action |
|---|---|
| `W / S` | Move Forward / Backward |
| `A / D` | Rotate Left / Right |
| `SPACE` | Shoot |
| `SHIFT` | Shield |
| `E` | Special Attack |
| `M` | Mute / Unmute |
| `ESC` | Pause |
| `R` | Return to Main Menu |

---

## 🛠️ Built With

- **Godot Engine 4**
- **GDScript**
- **Godot 2D Physics**
- **Git & GitHub**
- **GitHub Pages**

---

## 🧩 Game Architecture

The project follows Godot's scene-based architecture, separating gameplay systems into independent scenes and scripts.

The game uses **signals, scene instantiation, collision detection, physics processing and state management** to connect the player, enemies, projectiles, pickups, HUD, menus and overall game flow.

Version 3 expands the architecture considerably by introducing dedicated systems for:

- Mini-boss encounters
- UFO enemies
- Enemy projectiles
- Shield interactions
- Special attacks
- Energy management
- Life pickups
- Special energy pickups
- Persistent high scores
- Highest wave tracking
- Pause management
- Controls UI

---

### 🎮 Main Menu

The main menu acts as the entry point for the game.

Players can select their spaceship before starting a run, access the high-score screen and view the game's controls.

The menu also includes its own background music and custom visual presentation.

---

### 🚀 Spaceship Selection

Before starting the game, the player can choose between four spaceship designs.

The selected ship is carried into the gameplay session and determines the visual appearance of the player's spaceship.

Each ship also uses a matching laser style, giving every selectable spaceship its own visual identity.

---

### 🚀 Player Controller — `player.gd`

The player controller handles:

- Movement
- Acceleration
- Rotation
- Shooting
- Screen wrapping
- Shield activation
- Shield energy
- Special energy
- Special attack
- Invincibility
- Death
- Respawning

Movement uses acceleration and velocity limiting to reproduce the momentum-based movement associated with Asteroids.

The shield consumes energy while active and automatically recharges while inactive.

The special ability becomes available after reaching maximum special energy. Activating it causes the spaceship to rotate rapidly while automatically firing special projectiles for a limited duration.

---

### 🛡️ Shield System

Version 3 introduces a rechargeable shield.

While active, the shield protects the spaceship from incoming threats while continuously consuming shield energy.

When the shield is disabled, its energy gradually recharges.

The shield also provides visual feedback when impacts occur.

---

### ⚡ Special Attack

Destroying asteroids and certain enemies contributes energy toward the player's special meter.

Once fully charged, the player can activate the special attack with `E`.

During the ability:

- The spaceship rapidly rotates.
- Special projectiles are fired automatically.
- The attack remains active for a limited duration.
- The attack gradually slows before ending.

Special energy pickups can immediately refill the meter when it is not already full.

---

### ☄️ Asteroid System — `asteroid.gd`

Asteroids are implemented as independent `Area2D` objects responsible for their own movement, rotation, collision and destruction behavior.

The game includes multiple asteroid types and sizes with different fragmentation patterns.

Asteroid destruction awards score and contributes energy toward the player's special ability.

Larger asteroids can break into multiple smaller asteroids, increasing the amount of movement and danger present during later waves.

---

### 👾 Mini-Boss System

Version 3 introduces multiple mini-boss variants.

Mini-bosses appear as additional combat challenges during wave progression and use their own movement, health and attack systems.

The boss cycle changes as the player progresses, and defeating a mini-boss awards bonus score and special energy.

Different mini-boss encounters provide increasing rewards based on their position in the boss cycle.

---

### 🛸 UFO System

UFOs periodically appear during wave progression.

They move independently around the arena and provide an additional target beyond the standard asteroid encounters.

Destroying a UFO awards bonus score and contributes special energy to the player.

---

### ❤️ Life Pickups

Life pickups can appear during wave progression.

If the player has fewer than the maximum number of lives, collecting one restores a life.

If the player already has the maximum number of lives, the pickup cannot be collected.

---

### ⚡ Special Energy Pickups

Special energy pickups appear at random positions during wave progression.

Collecting one immediately fills the special energy meter.

If the special ability is already fully charged, the pickup remains available instead of being consumed.

A new pickup is generated as wave progression continues.

---

### 🌊 Infinite Wave System

The game progresses through continuously increasing waves.

Each completed wave leads to another wave with greater difficulty.

The progression system increases:

- ☄️ The number of asteroids
- ⚡ Asteroid movement speed
- 🌊 The current wave number
- 🎯 Overall survival difficulty

Additional enemies and pickups are integrated into the wave system, making later encounters increasingly dynamic.

There is no predefined final wave — the objective is to survive for as long as possible and achieve the highest score and wave possible.

---

### 🏆 Score and Progress Records

The game tracks score throughout each run.

Destroying asteroids, UFOs and mini-bosses contributes to the final score.

The game also maintains:

- High-score records
- Highest wave reached

These records allow players to compare new runs against their previous performance.

---

### 🎮 Game Manager — `game.gd`

The Game Manager coordinates the main gameplay systems and controls the overall game state.

Its responsibilities include:

- Starting gameplay
- Managing the current wave
- Spawning asteroids
- Increasing difficulty
- Tracking score
- Managing player lives
- Spawning life pickups
- Spawning special energy pickups
- Spawning UFOs
- Managing mini-boss encounters
- Handling asteroid destruction
- Handling player death
- Respawning the player
- Detecting game over
- Coordinating gameplay progression

Signals are used extensively to keep the individual gameplay components separated while allowing the Game Manager to coordinate their interactions.

---

### 🔫 Projectile Systems

The project contains multiple projectile systems.

Standard player lasers use the visual style associated with the selected spaceship.

The special ability uses dedicated special projectiles.

Enemies such as mini-bosses can also use their own projectiles against the player.

Projectiles interact with collision layers and gameplay systems independently depending on their purpose.

---

## 🔄 Gameplay Flow

The Version 3 gameplay flow can be summarized as:

```text
Main Menu
    │
    ├── High Scores
    │
    ├── Controls
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
    ├── Standard Laser
    ├── Shield
    └── Special Attack
    │
    ▼
Wave
    │
    ├── Asteroids
    ├── Mini-Boss
    ├── UFO
    ├── Life Pickup
    └── Special Energy Pickup
    │
    ▼
Game Manager
    │
    ├── Updates Score
    ├── Manages Lives
    ├── Manages Enemies
    ├── Manages Pickups
    ├── Handles Respawn
    ├── Tracks Wave
    └── Detects Game Over
    │
    ▼
Wave Cleared
    │
    ▼
Next Wave
    │
    ├── More Asteroids
    └── Higher Speed
    │
    ▼
Repeat
```

This separation keeps each gameplay component focused on its own responsibility while the **Game Manager** coordinates the overall game state.

---

## 📁 Project Structure

The project is organized around Godot scenes, scripts, resources, game assets and versioned builds.

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
│   ├── v2/
│   │   └── Web build — Version 2
│   │
│   └── v3/
│       └── Web build — Version 3
│
├── resources/
│
├── scenes/
│   ├── asteroid.tscn
│   ├── enemy_laser.tscn
│   ├── explosion.tscn
│   ├── game.tscn
│   ├── game_over_screen.tscn
│   ├── high_scores.tscn
│   ├── hud.tscn
│   ├── laser.tscn
│   ├── life_pickup.tscn
│   ├── main_menu.tscn
│   ├── mini_boss.tscn
│   ├── mini_boss_explosion.tscn
│   ├── pause_menu.tscn
│   ├── player.tscn
│   ├── special_laser.tscn
│   ├── special_pickup.tscn
│   ├── twinkle_star.tscn
│   ├── ufo.tscn
│   └── ufo_explosion.tscn
│
├── scripts/
│   ├── asteroid.gd
│   ├── enemy_laser.gd
│   ├── explosion.gd
│   ├── game.gd
│   ├── game_data.gd
│   ├── game_over_screen.gd
│   ├── high_scores.gd
│   ├── hud.gd
│   ├── laser.gd
│   ├── life_pickup.gd
│   ├── main_menu.gd
│   ├── mini_boss.gd
│   ├── mini_boss_explosion.gd
│   ├── pause_menu.gd
│   ├── player.gd
│   ├── special_laser.gd
│   ├── special_pickup.gd
│   ├── ufo.gd
│   └── ufo_explosion.gd
│
├── project.godot
├── export_presets.cfg
└── README.md
```

The `docs` directory contains the browser-playable builds used by GitHub Pages.

- `docs/v1/` preserves the original release.
- `docs/v2/` preserves Version 2.
- `docs/v3/` contains the latest Version 3 release.

This allows every major release to remain independently playable.

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

The repository contains versioned Web builds that can be played directly through GitHub Pages.

### Version 3 — Latest

[Play Version 3](https://patrickgusmao10.github.io/asteroids-godot/v3/)

### Version 2

[Play Version 2](https://patrickgusmao10.github.io/asteroids-godot/v2/)

### Version 1

[Play Version 1](https://patrickgusmao10.github.io/asteroids-godot/v1/)

Keeping each major version available makes it possible to follow the evolution of the project instead of replacing previous releases whenever a major update is published.

---

## 🎯 What I Practiced

Through this project, I practiced:

- Scene-based architecture in Godot
- GDScript programming
- 2D physics
- Player input handling
- Collision detection
- Collision layers and masks
- Scene instantiation
- Signals
- UI development
- Menu systems
- Game state management
- Persistent game data
- Wave-based gameplay systems
- Progressive difficulty
- Enemy systems
- Boss encounters
- Projectile systems
- Energy-based abilities
- Defensive mechanics
- Pickup systems
- Multiple player configurations
- Resource organization
- Audio integration
- Visual feedback
- Web export with Godot
- Windows export with Godot
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

### ✅ Version 2

Version 2 expanded the game with:

- 🎮 Main menu
- 🚀 Spaceship selection
- 🎵 Menu music
- ☄️ New asteroid variations
- 🌊 Infinite waves
- ⚡ Increasing asteroid speed
- ☄️ Increasing asteroid count
- 🔫 Ship-specific lasers

### ✅ Version 3 — Current Release

Version 3 expands the project into a more complete arcade experience with:

- 👾 Mini-boss encounters
- 🛸 UFO enemies
- 🛡️ Rechargeable shield
- ⚡ Special attack
- 🔋 Special energy system
- ❤️ Life pickups
- ⚡ Special energy pickups
- 🏆 Expanded scoring
- 📈 High-score tracking
- 🌊 Highest-wave tracking
- ⏸️ Pause system
- 🔇 Mute control
- 🎮 Controls screen
- 🎯 Custom cursor
- ✨ Additional visual polish
- 🔊 Expanded sound effects

### 🔭 Future Development

Version 3 represents the current feature-complete release of the project.

Future development may focus on additional balancing, visual polish and gameplay experimentation rather than a predefined next release.

---

## 👨‍💻 Author

**Patrick Gusmão**

Software Engineering student and developer exploring game development with Godot.

GitHub: **patrickgusmao10**

---

## ⭐ About This Repository

This repository documents the evolution of my learning process with **Godot 4** and game development.

The project began as a recreation of the classic Asteroids gameplay and evolved through multiple releases with increasingly complex gameplay systems.

Versions 1, 2 and 3 remain available to play, making it possible to directly experience the project's progression over time.

If you enjoyed the project, feel free to explore the source code and follow its future improvements.

☄️ **Destroy the asteroids. Survive the waves. Beat your high score.**