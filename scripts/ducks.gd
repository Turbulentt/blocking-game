extends Node3D

func _process(delta: float) -> void:
	rotate_x(delta * 1)  # Rotates 10 radian per second
