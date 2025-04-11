extends CanvasLayer

@onready var transition_rect = $ColorRect

func swipe_transition(to_room_path: String):
	transition_rect.position = Vector2(1920, 0)
	var tween = create_tween()
	tween.tween_property(transition_rect, "position", Vector2(0, 0), 0.7).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished

	get_tree().change_scene_to_file(to_room_path)

	await get_tree().create_timer(0.1).timeout
	tween = create_tween()
	tween.tween_property(transition_rect, "position", Vector2(-1920, 0), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
