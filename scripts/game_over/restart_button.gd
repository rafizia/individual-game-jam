extends LinkButton


func _on_pressed() -> void:
	TransitionManager.swipe_transition(GameState.current_level_path)
