extends "res://scripts/Enemy Scripts/enemy.gd"

# Basic red enemy — must be blocked, damages the player if it gets through
func _ready() -> void:
	speed = 150
	damage = 1
	enemy_radius = 8
	enemy_color = Color.RED
	should_be_blocked = true
	super._ready()  # Always call the base _ready() after setting your stats!
