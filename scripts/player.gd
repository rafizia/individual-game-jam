extends CharacterBody2D

@export var speed: float = 100.0
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_hitbox = $AttackHitbox

var last_direction: Vector2 = Vector2.DOWN
var is_attacking: bool = false
var health := 5
var knockback_velocity := Vector2.ZERO
var knockback_timer := 0.0
@export var knockback_duration := 0.2

func _physics_process(delta: float) -> void:
	var input_vector = Vector2.ZERO
	
	if knockback_timer > 0:
		velocity = knockback_velocity
		knockback_timer -= delta
		move_and_slide()
		return

	if not is_attacking:
		input_vector = Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		).normalized()

		velocity = input_vector * speed
		move_and_slide()

		if input_vector != Vector2.ZERO:
			last_direction = input_vector
			if abs(input_vector.x) > abs(input_vector.y):
				anim_sprite.play("walk_side")
				anim_sprite.flip_h = input_vector.x < 0
			else:
				anim_sprite.flip_h = false
				anim_sprite.play("walk_down" if input_vector.y > 0 else "walk_up")
		else:
			if abs(last_direction.x) > abs(last_direction.y):
				anim_sprite.play("idle_side")
				anim_sprite.flip_h = last_direction.x < 0
			else:
				anim_sprite.play("idle_down" if last_direction.y > 0 else "idle_up")
	
	if Input.is_action_just_pressed("attack") and not is_attacking:
		start_attack()

func start_attack():
	is_attacking = true
	attack_hitbox.monitoring = true
	attack_hitbox.get_node("CollisionShape2D").disabled = false
	print(attack_hitbox.monitoring)

	var anim = "attack_"
	if abs(last_direction.x) > abs(last_direction.y):
		anim += "side"
		anim_sprite.flip_h = last_direction.x < 0
	else:
		anim += "down" if last_direction.y > 0 else "up"
		anim_sprite.flip_h = false

	anim_sprite.play(anim)
	
	# Tunggu durasi animasi attack, lalu selesai
	await anim_sprite.animation_finished
	attack_hitbox.monitoring = false
	attack_hitbox.get_node("CollisionShape2D").disabled = true
	is_attacking = false
	
func take_damage(amount):
	health -= amount
	print("Player HP: ", health)

	modulate = Color.RED  # flash merah
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE

	if health <= 0:
		die()
		
func apply_knockback(from_position: Vector2, force: float):
	var direction = (global_position - from_position).normalized()
	knockback_velocity = direction * force
	knockback_timer = knockback_duration

func die():
	queue_free()
