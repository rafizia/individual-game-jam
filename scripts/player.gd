extends CharacterBody2D

signal healthChanged

@export var speed: float = 100.0
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_hitbox = $AttackHitbox
@onready var collision = $CollisionShape2D
@onready var score_label = $"../CanvasLayer/Score"

var last_direction: Vector2 = Vector2.DOWN
var is_attacking: bool = false
var health := 10
var knockback_velocity := Vector2.ZERO
var knockback_timer := 0.0
var is_dead = false
@export var knockback_duration := 0.2

@onready var currentHealth: int = health

func _physics_process(delta: float) -> void:
	var input_vector = Vector2.ZERO
	score_label.text = "Score: %d" % ScoreManager.score
	
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
			update_attack_hitbox_direction() 
			
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
		
func update_attack_hitbox_direction():
	var offset := 10
	if abs(last_direction.x) > abs(last_direction.y):
		if last_direction.x > 0:
			attack_hitbox.position = Vector2(offset, 0)
		else:
			attack_hitbox.position = Vector2(-offset, 0)
	else:
		if last_direction.y > 0:
			attack_hitbox.position = Vector2(0, offset)
		else:
			attack_hitbox.position = Vector2(0, -offset)

func start_attack():
	$SwordSFX.play()
	is_attacking = true
	attack_hitbox.monitoring = true
	attack_hitbox.get_node("CollisionShape2D").disabled = false

	var anim = "attack_"
	if abs(last_direction.x) > abs(last_direction.y):
		anim += "side"
		anim_sprite.flip_h = last_direction.x < 0
	else:
		anim += "down" if last_direction.y > 0 else "up"
		anim_sprite.flip_h = false

	anim_sprite.play(anim)
	
	await anim_sprite.animation_finished
	attack_hitbox.monitoring = false
	attack_hitbox.get_node("CollisionShape2D").disabled = true
	is_attacking = false
	
func take_damage(amount):
	if is_dead:
		return
	
	health -= amount
	healthChanged.emit()
	
	if health <= 0:
		collision.disabled = true
		die()
	else:
		modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		modulate = Color.WHITE
		
func apply_knockback(from_position: Vector2, force: float):
	var direction = (global_position - from_position).normalized()
	knockback_velocity = direction * force
	knockback_timer = knockback_duration

func die():
	call_deferred("change_to_game_over")

func change_to_game_over():
	GameState.current_level_path = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
