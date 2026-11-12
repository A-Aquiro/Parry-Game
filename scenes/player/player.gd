extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
@export var health_points := 100;
@export var attack_damage := 25

@export var knockback := 100
@export var knockback_lift := 50

@onready var animations := $PlayerAnimations
@onready var player_sword := $Sword

var current_state = player_states.MOVE
enum player_states {MOVE, DEAD}
var knockback_time := 0.0
var attacking := false
var attack_animation_id := 0
var facing_direction := Vector2.RIGHT
var sword_offset: Vector2

func _ready():
	sword_offset = player_sword.position
	add_to_group("player")
	player_sword.monitoring = true
	
func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta;

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY;
	
	if knockback_time > 0:
		knockback_time -= delta
	else:
		var direction := Input.get_axis("backward","forward")
		
		if attacking and direction != 0:
			attacking = false
			attack_animation_id += 1
		
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		if direction != 0:
			if direction > 0:
				facing_direction = Vector2.RIGHT 
			else:
				facing_direction = Vector2.LEFT
				
			animations.flip_h = direction < 0;
			update_sword_position()
	
	if !attacking:
		update_animations()
	move_and_slide();
	

func set_current_attack(direction: String) -> void:
	if current_state == player_states.DEAD:
		return
	
	attack_animation_id += 1
	var current_id = attack_animation_id
	
	attacking = true
	animations.play("attack_" + direction)

	var directions := {
		"up": Vector2.UP,
		"down": Vector2.DOWN,
		"left": Vector2.LEFT,
		"right": Vector2.RIGHT
	}

	if not directions.has(direction):
		return
	
	update_sword_position()
	
	await get_tree().physics_frame
	
	
	for area in player_sword.get_overlapping_areas():
		
		if area.is_in_group("enemy_swords"):
			var enemy = area.get_parent()
			enemy.receive_parry(direction, self)
			break
			
	for body in player_sword.get_overlapping_bodies():
		if body.is_in_group("enemies"):
			body.receive_player_attack(attack_damage)
	
	await animations.animation_finished
	
	if current_id == attack_animation_id:
		attacking = false
		update_sword_position()
		update_animations()
	
func take_damage(amount: int):
	if current_state == player_states.DEAD:
		return
	
	health_points -= amount
	
	if health_points <= 0:
		current_state = player_states.DEAD

func apply_knockback(enemy_position: Vector2):
	var direction = global_position - enemy_position
	
	if direction.length_squared() == 0:
		direction = Vector2.RIGHT
	else:
		direction = direction.normalized()
	
	velocity.x = direction.x * knockback
	velocity.y -= knockback_lift
	
	knockback_time = 0.2

func update_animations():
	
	if current_state == player_states.MOVE:
		if !is_on_floor():
			if velocity.y < 0:
				animations.play("jump")
			else:
				animations.play("fall")
			
		elif velocity.x == 0:
			animations.play("idle")
		else:
			animations.play("walk")
	
	else:
		return
	
func update_sword_position():
	if facing_direction == Vector2.RIGHT:
		player_sword.position = sword_offset
	else:
		player_sword.position = Vector2(-sword_offset.x, sword_offset.y)
