extends Node2D

@export var enemy_scene: PackedScene  # Drag your Enemy.tscn here in inspector
@export var max_spawn_interval: float = 1.0  # Time between spawns in seconds
@export var min_spawn_interval: float = 0.25
@export var current_spawn_interval: float = 1.0
@export var decay_rate: float = 0.985
@export var spawn_distance: float = 1000.0  # Distance from center to spawn enemies

@export var player: Node2D
var spawn_timer: float = 0.0
var elapsed_time: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawn_timer += delta
	elapsed_time += delta
	
	if spawn_timer >= current_spawn_interval:
		spawn_enemy()
		spawn_timer = 0.0
		current_spawn_interval = max(min_spawn_interval, max_spawn_interval * pow(decay_rate, elapsed_time))

func spawn_enemy():
	if enemy_scene == null or player == null:
		return
	
	var enemy = enemy_scene.instantiate()
	
	enemy.died.connect(_on_enemy_died)
	enemy.player_lost.connect(_on_player_lost)
	
	var angle = randf() * TAU
	
	var spawn_offset = Vector2(cos(angle), sin(angle)) * spawn_distance
	var spawn_pos = spawn_offset #player.global_position + spawn_offset
	#get_viewport().get_visible_rect().size / 2.0
	
	enemy.global_position = spawn_pos
	
	enemy.target = player
	
	if randf() <= 0.2:
		enemy.type = 'star'
		enemy.should_be_blocked = false
	else:
		enemy.type = 'enemy'
	
	var difficulty = inverse_lerp(max_spawn_interval, min_spawn_interval, current_spawn_interval)
	var speed_multiplier = lerp(1.0, 4.0, difficulty)
	enemy.speed = enemy.speed * speed_multiplier
	
	get_tree().current_scene.add_child(enemy)

func _on_enemy_died(points):
	get_node("../CanvasLayer").add_points(points)

func _on_player_lost():
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
