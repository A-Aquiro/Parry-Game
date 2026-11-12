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

func _ready():
	add_to_group("players")
	
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
		
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		if direction != 0:
			animations.flip_h = direction < 0;
	
	if !attacking:
		update_animations()
	move_and_slide();

func set_current_attack(direction: String) -> void:
	attack_animation_id += 1
	var current_id = attack_animation_id
	
	attacking = true
	animations.play("attack_" + direction)
	
	if current_state == player_states.DEAD:
		return

	var directions := {
		"up": Vector2.UP,
		"down": Vector2.DOWN,
		"left": Vector2.LEFT,
		"right": Vector2.RIGHT
	}

	if not directions.has(direction):
		return

	player_sword.position = directions[direction] * 35.0

	await get_tree().physics_frame


	for area in player_sword.get_overlapping_areas():


		if area.is_in_group("enemy_swords"):

			var enemy = area.get_parent()


			if enemy.has_method("receive_parry"):
				enemy.receive_parry(direction, self)

			return
	await animations.animation_finished

	if current_id == attack_animation_id:
		attacking = false
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
	
