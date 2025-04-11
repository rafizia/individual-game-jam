extends StaticBody2D

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var collision_shape_2d_hitbox: CollisionShape2D = $Area2D/CollisionShape2D
@export var object_id := ""
@export var room_name := ""

func mark_break():
	RoomManager.mark_object_break(room_name, object_id)
	
func change_anim():
	collision_shape_2d.disabled = true
	collision_shape_2d_hitbox.disabled = true
	anim_sprite.play("broke")
