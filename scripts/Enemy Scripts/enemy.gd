extends Area2D

# Base stats — each enemy type overrides these in their own script
@export var speed: float = 150
@export var damage: int = 1
@export var enemy_radius: float = 8
@export var enemy_color: Color = Color.WHITE

var collision_shape

var target: Node2D = null
var direction: Vector2 = Vector2.ZERO
var should_be_blocked: bool = true

signal died(points)
#signal player_lost()
signal player_damage(damage)

func _ready() -> void:
	collision_shape = get_node("CollisionShape2D")  # fetch manually
	var circle = CircleShape2D.new()
	circle.radius = enemy_radius
	collision_shape.shape = circle
	
	if target:
		direction = (target.global_position - global_position).normalized()
	
	area_entered.connect(_on_area_entered)

func _draw() -> void:
	draw_circle(Vector2.ZERO, enemy_radius, enemy_color)

func _process(delta: float) -> void:
	global_position += direction * speed * delta
	
	if global_position.length() > 2000:
		queue_free()

func _on_area_entered(body) -> void:
	if body.name == "Player" && should_be_blocked:
		emit_signal("player_damage", damage)
		queue_free()
	elif body.name == "Player" && not should_be_blocked:
		emit_signal("died", 100)
		queue_free()
	elif body.name == "Shield" && should_be_blocked:
		emit_signal("died", 100)
		queue_free()
	elif body.name == "Shield" && not should_be_blocked:
		queue_free()
