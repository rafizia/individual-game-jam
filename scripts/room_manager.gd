extends Node

var room_container: Node
var player: Node
var current_room: Node = null
var defeated_enemies = {}
var broke_objects = {}
var label: Node
	
func load_room(path: String, spawn_position: Vector2):	
	if current_room and is_instance_valid(current_room):
		current_room.queue_free()
		current_room = null

	var scene = load(path)
	var new_room = scene.instantiate()
	room_container.add_child(new_room)
	current_room = new_room

	player.global_position = spawn_position
	
	var tilemap = current_room.get_node("TileMapLayer")
	set_camera_limits(tilemap)
	
	for enemy in current_room.get_tree().get_nodes_in_group("enemy"):
		if is_enemy_defeated(path, enemy.enemy_id):
			enemy.queue_free()
			
	for object in current_room.get_tree().get_nodes_in_group("object"):
		if is_object_broke(path, object.object_id):
			object.change_anim()

func set_camera_limits(tilemap: TileMapLayer):
	if not tilemap:
		return

	var camera: Camera2D = player.get_node_or_null("Camera2D")
	var used_rect: Rect2i = tilemap.get_used_rect()
	var tile_map_size := tilemap.tile_set.get_tile_size()
	
	camera.limit_left = used_rect.position.x * tile_map_size.x
	camera.limit_top = used_rect.position.y * tile_map_size.y
	camera.limit_right = (used_rect.position.x + used_rect.size.x) * tile_map_size.x
	camera.limit_bottom = (used_rect.position.y + used_rect.size.y) * tile_map_size.y

func mark_enemy_defeated(room_name: String, enemy_id: String):
	if not defeated_enemies.has(room_name):
		defeated_enemies[room_name] = []
	defeated_enemies[room_name].append(enemy_id)

func is_enemy_defeated(room_name: String, enemy_id: String) -> bool:
	return room_name in defeated_enemies and enemy_id in defeated_enemies[room_name]
	
func mark_object_break(room_name: String, object_id: String):
	if not broke_objects.has(room_name):
		broke_objects[room_name] = []
	broke_objects[room_name].append(object_id)

func is_object_broke(room_name: String, object_id: String) -> bool:
	return room_name in broke_objects and object_id in broke_objects[room_name]

func stage_clear():
	label.visible = true
	await get_tree().create_timer(5.0).timeout
	label.visible = false

	var level_scene = get_tree().current_scene
	level_scene.swipe_transition_to_next_level()
	
func show_game_over():
	var level_scene = get_tree().current_scene
	level_scene.swipe_transition_game_over()
