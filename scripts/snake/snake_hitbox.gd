extends Area2D

@onready var bat: CharacterBody2D = $".."

func _on_area_entered(area):
	if area.name == "AttackHitbox":
		bat.take_damage(1)
