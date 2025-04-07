extends Node

var room_container: Node
var player: Node
var current_room: Node = null
	
func load_room(path: String, spawn_position: Vector2):
	# Hapus ruangan lama kalau ada		
	if current_room:
		current_room.queue_free()
		current_room = null

	# Load ruangan baru
	var scene = load(path)
	var new_room = scene.instantiate()
	room_container.add_child(new_room)
	current_room = new_room

	# Pindahkan player
	player.global_position = spawn_position
	
	var tilemap = current_room.get_node("TileMapLayer")
	set_camera_limits(tilemap)

func set_camera_limits(tilemap: TileMapLayer):
	if not tilemap:
		return
		
	var camera: Camera2D = get_node_or_null("/root/Level1/Player/Camera2D")
	var used_rect: Rect2i = tilemap.get_used_rect()
	var tile_map_size := tilemap.tile_set.get_tile_size()
	
	camera.limit_left = used_rect.position.x * tile_map_size.x
	camera.limit_top = used_rect.position.y * tile_map_size.y
	camera.limit_right = (used_rect.position.x + used_rect.size.x) * tile_map_size.x
	camera.limit_bottom = (used_rect.position.y + used_rect.size.y) * tile_map_size.y
