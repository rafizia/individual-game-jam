extends LinkButton


func _on_pressed() -> void:
	ScoreManager.score = 0
	TransitionManager.swipe_transition("res://scenes/main_menu.tscn")
