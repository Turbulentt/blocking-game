extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CenterContainer/VBoxContainer/Button.pressed.connect(_on_restart_pressed)
	$CenterContainer/VBoxContainer/ScoreLabel.text = "Final Score: " + str(GameManager.score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_restart_pressed():
	GameManager.reset_score()
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.queue_free()
	get_tree().change_scene_to_file("res://scenes/game.tscn")
