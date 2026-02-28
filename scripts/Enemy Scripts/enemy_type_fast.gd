extends "res://scripts/Enemy Scripts/enemy.gd"

# Fast small enemy
func _ready() -> void:
	speed = 250        # Much faster
	damage = 2         # Hits harder
	enemy_radius = 4   # Smaller hitbox
	enemy_color = Color.ORANGE
	should_be_blocked = true
	super._ready()
