extends "res://scripts/Enemy Scripts/enemy.gd"

# Yellow star — gives points on contact to player
func _ready() -> void:
	speed = 150
	damage = 0
	enemy_radius = 8
	enemy_color = Color.YELLOW
	should_be_blocked = false
	super._ready()
