extends LinkButton


func _on_pressed() -> void:
	TransitionManager.swipe_transition("res://scenes/main_menu.tscn")
