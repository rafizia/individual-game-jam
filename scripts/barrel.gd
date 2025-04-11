extends Area2D

@onready var anim_sprite: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var collision_shape_2d: CollisionShape2D = $"../CollisionShape2D"
@onready var collision_shape_2d_hitbox: CollisionShape2D = $CollisionShape2D
@onready var barrel = $".."
@export var object_id := ""
@export var room_name := ""

func _on_area_entered(area):
	if area.name == "AttackHitbox":
		break_barrel()

func break_barrel():
	anim_sprite.play("break")
	await anim_sprite.animation_finished
	collision_shape_2d.disabled = true
	collision_shape_2d_hitbox.disabled = true
	barrel.mark_break()
	
