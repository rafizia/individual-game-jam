extends Node2D

@onready var transition_rect = $TransitionLayer/TransitionRect
@onready var tween = create_tween()

func _ready():
	RoomManager.room_container = $RoomContainer
	RoomManager.player = $Player
	RoomManager.label = $CanvasLayer2/Label
	RoomManager.score_label = $CanvasLayer2/ScoreLabelFinish
	RoomManager.load_room("res://scenes/Level_3/room_1.tscn", Vector2(41, 219))

func swipe_transition(to_room_path: String, spawn_position: Vector2):
	# Mulai swipe masuk (dari kanan ke tengah)
	transition_rect.position = Vector2(1920, 0) # Start dari kanan
	tween = create_tween()
	tween.tween_property(transition_rect, "position", Vector2(0, 0), 0.7).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	await tween.finished

	# Load ruangan
	RoomManager.load_room(to_room_path, spawn_position)

	await get_tree().create_timer(0.1).timeout

	# Swipe keluar (ke kiri layar)
	tween = create_tween()
	tween.tween_property(transition_rect, "position", Vector2(-1920, 0), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func swipe_transition_to_next_level():
	TransitionManager.swipe_transition("res://scenes/Level_4/level_4.tscn")
