extends LinkButton

func _on_pressed() -> void:
	TransitionManager.swipe_transition("res://scenes/Level_1/level_1.tscn")
