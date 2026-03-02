extends Node2D

var radius = 50

func _ready() -> void:
	pass 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var player_pos = get_parent().global_position
	
	var direction = (mouse_pos - player_pos).normalized()
	
	var angle = direction.angle()
	
	rotation = angle
	
	self.global_position = player_pos + Vector2(cos(angle), sin(angle)) * radius
