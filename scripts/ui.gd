extends CanvasLayer

@onready var score_label = $ScoreLabel
@onready var health_bar = $HealthBar
@onready var health_label = $HealthBar/HealthLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score_label.text = "Score: 0"
	
	health_bar.max_value = GameManager.max_health
	health_bar.value = GameManager.health
	update_label()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func add_points(amount):
	GameManager.score += amount
	score_label.text = "Score: %d" % GameManager.score

func update_health():
	health_bar.max_value = GameManager.max_health
	health_bar.value = GameManager.health
	update_label()

func update_label():
	health_label.text = "%d / %d" % [health_bar.value, health_bar.max_value]
