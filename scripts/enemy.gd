extends Area2D

@export var speed: float = 150
@export var damage: int = 1

var enemy_radius: float = 8

@onready var collision_shape = $CollisionShape2D

var target: Node2D = null
var direction: Vector2 = Vector2.ZERO

var type: String = ''
var should_be_blocked: bool = true

signal died(points)
signal player_lost()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_shape.shape = collision_shape.shape.duplicate()
	collision_shape.shape.radius = enemy_radius
	
	if target: direction = (target.global_position - global_position).normalized()
	
	area_entered.connect(_on_area_entered)

func _draw():
	if type == 'enemy':
		draw_circle(Vector2.ZERO, enemy_radius, Color.RED)
	elif type == 'star':
		draw_circle(Vector2.ZERO, enemy_radius, Color.YELLOW)
	else:
		print('Type does not match')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += direction * speed * delta
	
	if global_position.length() > 2000:
		queue_free()

func _on_area_entered(body):
	if body.name == "Player" && should_be_blocked:
		emit_signal("player_lost")
		queue_free()
	if body.name == "Player" && not should_be_blocked:
		emit_signal("died", 100)
		queue_free()
	if body.name == "Shield" && should_be_blocked:
		emit_signal("died", 100)
		queue_free()
	if body.name == "Shield" && not should_be_blocked:
		queue_free()
