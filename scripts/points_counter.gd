extends CanvasLayer

@onready var score_label = $ScoreLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score_label.text = "Score: 0"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func add_points(amount):
	GameManager.score += amount
	score_label.text = "Score: %d" % GameManager.score
