extends Area2D

@export var damage := 1
@export var attack_cooldown := 0.0

var can_attack := true

func _on_body_entered(body: Node2D) -> void:
	if can_attack and body.name == "Player":
		if body.has_method("take_damage"):
			body.take_damage(damage)
			body.apply_knockback(global_position, 100)
			can_attack = false
			await get_tree().create_timer(attack_cooldown).timeout
			can_attack = true
