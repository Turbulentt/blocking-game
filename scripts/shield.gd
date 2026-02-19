extends Node2D

var radius = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var player_pos = get_parent().global_position
	
	var direction = (mouse_pos - player_pos).normalized()
	
	var angle = direction.angle()
	
	rotation = angle
	
	self.global_position = player_pos + Vector2(cos(angle), sin(angle)) * radius
