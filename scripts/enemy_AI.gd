extends CharacterBody2D

@export var speed := 30
@export var health := 3
@export var chase_range := 150
@export var patrol_distance := 48
@export var patrol_delay := 0.5
@export var enemy_id := ""
@export var room_name := ""
@export var player_path := "Level1/Player"
@export var score := 10
@export var stun_duration := 2.0
@export var hits_to_stun := 3

var player: Node2D = null
var patrol_dir := Vector2.ZERO
var patrol_origin := Vector2.ZERO
var patrol_timer := 0.0
var stun_timer := 0.0
var is_stunned := false
var hit_count := 0

enum State { IDLE, PATROL, CHASE, HIT }
var state: State = State.PATROL
var is_hit := false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area = $AttackArea
@onready var stun_label = $StunLabel

func _ready():
	pick_new_patrol_direction()
	sprite.play("walk")

func _physics_process(delta):
	if is_stunned:
		stun_timer -= delta
		if stun_timer <= 0:
			is_stunned = false
			hit_count = 0
			
			if attack_area:
				attack_area.set_deferred("monitoring", true)
			
			if stun_label:
				stun_label.visible = false
		else:
			velocity = Vector2.ZERO
			move_and_slide()
			return
			
	if state == State.HIT:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if player == null or not is_instance_valid(player):
		player = get_tree().get_root().get_node_or_null(player_path)
	
	if player:
		var distance_to_player = global_position.distance_to(player.global_position)

		if distance_to_player < chase_range:
			state = State.CHASE
			var dir = (player.global_position - global_position).normalized()
			velocity = dir * speed
			sprite.play("walk")
			sprite.flip_h = velocity.x > 0
		else:
			state = State.PATROL
			handle_patrol(delta)

	move_and_slide()

func handle_patrol(delta):
	var offset = global_position - patrol_origin
	if offset.length() >= patrol_distance:
		patrol_timer -= delta
		if patrol_timer <= 0:
			pick_new_patrol_direction()

	velocity = patrol_dir * speed
	sprite.play("walk")
	sprite.flip_h = velocity.x > 0
	
	if is_on_wall():
		pick_new_patrol_direction()

func pick_new_patrol_direction():
	var dirs = [
		Vector2.LEFT,
		Vector2.RIGHT,
		Vector2.UP,
		Vector2.DOWN
	]
	patrol_dir = dirs[randi() % dirs.size()]
	patrol_origin = global_position
	patrol_timer = patrol_delay

func take_damage(amount):
	if is_hit or is_stunned:
		return

	health -= amount
	is_hit = true
	state = State.HIT
	sprite.play("hit")
	
	hit_count += 1
	if hit_count >= hits_to_stun and health > 0:
		stun()

	if health <= 0:
		sprite.play("hit")
		await sprite.animation_finished
		die()
	else:
		await sprite.animation_finished
		is_hit = false
		state = State.IDLE

func die():
	if attack_area:
		attack_area.set_deferred("monitoring", false)
	sprite.play("dead")
	await sprite.animation_finished
	RoomManager.mark_enemy_defeated(room_name, enemy_id)
	ScoreManager.add_score(score)
	queue_free()
	
func stun():
	is_stunned = true
	stun_timer = stun_duration
	state = State.IDLE
	
	if stun_label:
		stun_label.visible = true

	if attack_area:
		attack_area.set_deferred("monitoring", false)
