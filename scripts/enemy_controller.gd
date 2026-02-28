extends Node2D

@export var enemy_scene: PackedScene

@export var max_spawn_interval: float = GameManager.max_spawn_interval # Maximum seconds between spawns
@export var min_spawn_interval: float = GameManager.min_spawn_interval # Minimum seconds between spawns

# Decay rate changes how fast the game will speed up from max to min interval
@export var decay_rate: float = GameManager.decay_rate # Value between 0 and 1. 0.99 -> low decay; 0.9 -> fast decay

@export var spawn_distance: float = GameManager.spawn_distance # How far away from player enemies spawn

@export var current_spawn_interval: float = 1.0 
@export var player: Node2D

var spawn_timer: float = 0.0
var elapsed_time: float = 0.0

# Wave management
var current_wave_enemies: Array = []  # Queue of enemies to spawn
var current_enemy_index: int = 0      # Which enemy we're on in the wave

@onready var wave_generator: Node = $WaveGenerationNode

func _ready() -> void:
	# Start at the slowest (max interval) spawn rate for a clean difficulty reset.
	current_spawn_interval = max_spawn_interval
	spawn_timer = 0.0
	elapsed_time = 0.0
	current_wave_enemies = wave_generator.generate_new_wave()  # Start with a wave ready

func _process(delta: float) -> void:
	spawn_timer += delta
	elapsed_time += delta
	
	if spawn_timer >= current_spawn_interval:
		spawnManager()
		spawn_timer = 0.0
		current_spawn_interval = max(min_spawn_interval, max_spawn_interval * pow(decay_rate, elapsed_time))

func get_viewport_center() -> Vector2:
	return get_viewport().get_visible_rect().size / 2

func spawnManager():
	# Check if current wave is complete
	if current_enemy_index >= current_wave_enemies.size():
		current_wave_enemies =  wave_generator.generate_new_wave()
		current_enemy_index = 0
	
	# Spawn the next enemy from the current wave
	if current_enemy_index < current_wave_enemies.size():
		var enemy_data = current_wave_enemies[current_enemy_index]
		spawn_enemy(enemy_data.type, enemy_data.angle, enemy_data.blocked)
		current_enemy_index += 1
	

# ===== SPAWNING =====
func spawn_enemy(type: String, angle: float, should_be_blocked: bool):
	if enemy_scene == null or player == null:
		return
	
	var enemy = enemy_scene.instantiate()
	
	# Set correct script
	match type:
		"enemy":
			enemy.set_script(preload("res://scripts/Enemy Scripts/enemy_type_basic.gd"))
		"star":
			enemy.set_script(preload("res://scripts/Enemy Scripts/enemy_type_star.gd"))
		"fast":
			enemy.set_script(preload("res://scripts/Enemy Scripts/enemy_type_fast.gd"))
	
	var viewport_center = get_viewport_center()
	enemy.global_position = viewport_center + Vector2(cos(angle), sin(angle)) * spawn_distance
	enemy.target = player
	
	# Add to tree first; triggers _ready
	get_tree().root.add_child(enemy)
	
	enemy.died.connect(_on_enemy_died)
	enemy.player_damage.connect(_on_player_damage)
	
	# now apply multiplier
	var difficulty = 0
	if max_spawn_interval == min_spawn_interval:
		difficulty = 4
		enemy.speed = enemy.speed * 4
	else:
		difficulty = clamp(inverse_lerp(max_spawn_interval, min_spawn_interval, current_spawn_interval), 0.0, 1.0)
		enemy.speed = enemy.speed * lerp(1.0, 4.0, difficulty)

func _on_enemy_died(points):
	get_node("../CanvasLayer").add_points(points)

func _on_player_damage(damage):
	GameManager.take_damage(damage)
	get_node("../CanvasLayer").update_health()

func _change_scene():
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
