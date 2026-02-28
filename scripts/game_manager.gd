extends Node

var score: int = 0

# --- MODIFIERS --- # 
var max_spawn_interval: float = 0.8 # Maximum seconds between spawns
var min_spawn_interval: float = 0.15 # Minimum seconds between spawns
# Decay rate changes how fast the game will speed up from max to min interval
var decay_rate: float = 0.985 # Value between 0 and 1. 0.99 -> low decay; 0.9 -> fast decay
var spawn_distance: float = 600 # How far away from center enemies spawn
var max_health: int = 5 # Health of the player object
var player_speed: float = 200.0 # Speed the player moves at
var enemy_turn_rate: float = 3.0 # Changes how aggressivly enemies track the player
# --- MODIFIERS --- #

var health: int = max_health

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func reset_score():
	score = 0

func take_damage(damage: int):
	health -= damage
	if health <= 0:
		health = max_health
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
