extends Node2D

@onready var transition_rect = $TransitionLayer/TransitionRect
@onready var tween = create_tween()

func _ready():
	RoomManager.room_container = $RoomContainer
	RoomManager.player = $Player
	RoomManager.label = $CanvasLayer2/Label
	RoomManager.load_room("res://scenes/Level_1/room_4.tscn", Vector2(-161, 226))

func swipe_transition(to_room_path: String, spawn_position: Vector2):
	transition_rect.position = Vector2(1920, 0)
	tween = create_tween()
	tween.tween_property(transition_rect, "position", Vector2(0, 0), 0.7).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	await tween.finished

	RoomManager.load_room(to_room_path, spawn_position)

	await get_tree().create_timer(0.1).timeout

	tween = create_tween()
	tween.tween_property(transition_rect, "position", Vector2(-1920, 0), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func swipe_transition_to_next_level():
	TransitionManager.swipe_transition("res://scenes/Level_2/level_2.tscn")
	
func swipe_transition_game_over():
	TransitionManager.swipe_transition("res://scenes/game_over.tscn")
