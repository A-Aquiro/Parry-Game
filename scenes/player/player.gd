extends CharacterBody2D

const SPEED = 175.0
const JUMP_VELOCITY = -400.0
@export var max_health_points := 20
@export var attack_damage := 25

@export var knockback := 100
@export var knockback_lift := 50

@onready var player_anim := $PlayerAnimations
@onready var sword_anim := $Sword/SwordAnimations

@onready var player_sword := $Sword

var current_state = player_states.MOVE
enum player_states {MOVE, PREATTACK, ATTACKING, DEAD}
var knockback_time := 0.0
var attack_animation_id := 0
var facing_direction := Vector2.RIGHT
var sword_offset: Vector2
var spawn : Vector2
var health_points := 20;
var can_parry_jump := true

func _ready():
	sword_offset = player_sword.position
	add_to_group("player")
	player_sword.monitoring = true
	spawn = global_position
	sword_anim.hide()

func _physics_process(delta: float) -> void:
	if current_state == player_states.DEAD:
		velocity = Vector2.ZERO
		global_position = spawn
		current_state = player_states.MOVE
		health_points = max_health_points
		current_state = player_states.MOVE
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta;

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY;
	
	if is_on_floor():
		can_parry_jump = true 
		
	if knockback_time > 0:
		knockback_time -= delta
	else:
		var direction := Input.get_axis("backward","forward")
		
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		if direction != 0:
			if direction > 0:
				facing_direction = Vector2.RIGHT 
			else:
				facing_direction = Vector2.LEFT
				
			player_anim.flip_h = direction < 0
			sword_anim.flip_h = direction < 0;
			update_sword_position()
	
	if current_state != player_states.ATTACKING:
		update_player_anim()
	move_and_slide();
	parry_jump()
	

func set_current_attack(direction: String) -> void:
	if current_state == player_states.DEAD or current_state == player_states.ATTACKING:
		return
		
	var directions := {
		"up": Vector2.UP,
		"down": Vector2.DOWN,
		"left": Vector2.LEFT,
		"right": Vector2.RIGHT
	}
	
	if not directions.has(direction):
		return
	
	attack_animation_id += 1
	var current_id = attack_animation_id
	
	current_state = player_states.ATTACKING
	sword_anim.show()
	sword_anim.play(direction)
	
	update_sword_position()
	
	await get_tree().physics_frame
	
	for area in player_sword.get_overlapping_areas():
		
		if area.is_in_group("enemy_swords"):
			var enemy = area.get_parent()
			enemy.receive_parry(direction, self)
			
			parry_jump()
			break
			
	for body in player_sword.get_overlapping_bodies():
		if body.is_in_group("enemies"):
			body.receive_player_attack(attack_damage)
			
			if direction == "down" and not is_on_floor():
				velocity.y = JUMP_VELOCITY * 0.5
				
	
	if current_id == attack_animation_id:
		current_state = player_states.ATTACKING
		update_sword_position()
		update_player_anim()
	
	current_state = player_states.MOVE

func take_damage(enemy_position: Vector2, damage: int):
	var direction = global_position - enemy_position
	
	if direction.length_squared() == 0:
		direction = Vector2.RIGHT
	else:
		direction = direction.normalized()
	
	velocity.x = direction.x * knockback
	velocity.y -= knockback_lift
	
	knockback_time = 0.2
	health_points -= damage
	print("-", damage)
	if health_points <= 0:
		current_state = player_states.DEAD

func update_player_anim():
	
	if current_state != player_states.DEAD:
		if current_state == player_states.PREATTACK:
			player_anim.play("swordup")
			current_state = player_states.ATTACKING
		elif velocity.x == 0:
			player_anim.play("idle")
		else:
			player_anim.play("walk")
	
func update_sword_position():
	if facing_direction == Vector2.RIGHT:
		player_sword.position = sword_offset
	else:
		player_sword.position = Vector2(-sword_offset.x, sword_offset.y)

func parry_jump():
	if can_parry_jump == false:
		return
	
	if is_on_wall() and current_state == player_states.ATTACKING:
		var wall_normal = get_wall_normal()
		
		velocity.x  = get_wall_normal().x * SPEED
		velocity.y = JUMP_VELOCITY
		
		can_parry_jump = false
