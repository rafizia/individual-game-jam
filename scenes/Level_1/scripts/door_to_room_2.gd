extends Area2D

@export var target_room_path: String = "res://scenes/Level_1/room_2.tscn"
@export var spawn_position: Vector2 = Vector2(-160, 5)

func _on_body_entered(body):
	if body.name == "Player":
		get_tree().current_scene.swipe_transition(target_room_path, spawn_position)
