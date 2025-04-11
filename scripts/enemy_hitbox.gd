extends Area2D

@onready var enemy: CharacterBody2D = $".."

func _on_area_entered(area):
	if area.name == "AttackHitbox":
		enemy.take_damage(1)
