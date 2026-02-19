extends Node2D

@export var enemy_scene: PackedScene
@export var max_spawn_interval: float = 1.0
@export var min_spawn_interval: float = 0.25
@export var current_spawn_interval: float = 1.0
@export var decay_rate: float = 0.985
@export var spawn_distance: float = 1000.0

@export var player: Node2D
var spawn_timer: float = 0.0
var elapsed_time: float = 0.0

# Wave management
var current_wave_enemies: Array = []  # Queue of enemies to spawn
var current_enemy_index: int = 0      # Which enemy we're on in the wave

func _ready() -> void:
	generate_new_wave()  # Start with a wave ready

func _process(delta: float) -> void:
	spawn_timer += delta
	elapsed_time += delta
	
	if spawn_timer >= current_spawn_interval:
		spawnManager()
		spawn_timer = 0.0
		current_spawn_interval = max(min_spawn_interval, max_spawn_interval * pow(decay_rate, elapsed_time))

func spawnManager():
	# Check if current wave is complete
	if current_enemy_index >= current_wave_enemies.size():
		generate_new_wave()
	
	# Spawn the next enemy from the current wave
	if current_enemy_index < current_wave_enemies.size():
		var enemy_data = current_wave_enemies[current_enemy_index]
		spawn_enemy(enemy_data.type, enemy_data.angle, enemy_data.blocked)
		current_enemy_index += 1

func generate_new_wave():
	# List of all available wave generation functions
	var wave_functions = [
		generate_wave_random,
		generate_wave_circle,
		generate_wave_line,
		# Add more wave functions here
	]
	
	# Pick a random wave
	var wave_func = wave_functions.pick_random()
	current_wave_enemies = wave_func.call()
	current_enemy_index = 0
	
	print("New wave started: ", wave_func.get_method(), " with ", current_wave_enemies.size(), " enemies")

# ===== WAVE GENERATION FUNCTIONS =====
# Each function returns an Array of enemy data dictionaries

func generate_wave_random() -> Array:
	var enemies = []
	var count = randi_range(5, 15)  # Random number of enemies
	
	for i in count:
		var type = 'star' if randf() <= 0.2 else 'enemy'
		var blocked = (type == 'enemy')
		var angle = randf() * TAU
		
		enemies.append({
			"type": type,
			"angle": angle,
			"blocked": blocked
		})
	
	return enemies

func generate_wave_circle() -> Array:
	var enemies = []
	var count = randi_range(8, 18)  # Enemies in a circle
	
	var angle_modifier = randi_range(0, 359)
	
	for i in count:
		var angle = (TAU / count) * i + angle_modifier # Evenly spaced
		enemies.append({
			"type": 'enemy',
			"angle": angle,
			"blocked": true
		})
	
	return enemies

func generate_wave_line() -> Array:
	var enemies = []
	var count = randi_range(4, 10)
	var base_angle = randf() * TAU  # Random direction
	
	for i in count:
		# All from same direction, slight spread
		var angle = base_angle + (randf() - 0.5) * 0.3
		enemies.append({
			"type": 'enemy',
			"angle": angle,
			"blocked": true
		})
	
	return enemies

# ===== SPAWNING =====

func spawn_enemy(type: String, angle: float, should_be_blocked: bool):
	if enemy_scene == null or player == null:
		return
	
	var enemy = enemy_scene.instantiate()
	
	enemy.died.connect(_on_enemy_died)
	enemy.player_lost.connect(_on_player_lost, CONNECT_DEFERRED)
	
	var spawn_offset = Vector2(cos(angle), sin(angle)) * spawn_distance
	var spawn_pos = spawn_offset
	
	enemy.global_position = spawn_pos
	enemy.target = player
	enemy.type = type
	enemy.should_be_blocked = should_be_blocked
	
	var difficulty = inverse_lerp(max_spawn_interval, min_spawn_interval, current_spawn_interval)
	var speed_multiplier = lerp(1.0, 4.0, difficulty)
	enemy.speed = enemy.speed * speed_multiplier
	
	get_tree().current_scene.add_child(enemy)

func _on_enemy_died(points):
	get_node("../CanvasLayer").add_points(points)

func _on_player_lost():
	call_deferred("_change_scene")

func _change_scene():
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
