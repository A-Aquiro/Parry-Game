extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
@export var health_points := 100;
@export var attack_damage := 10;
@export var attack_duration := 0.2
@export var attack_cooldown := 0.3
@export var enemy: Enemy

@onready var animations := $PlayerAnimations
@onready var slash := $Slashes 
@onready var sword_hitbox := $Sword

var current_attack: String = "";
var hit_targets: Array[Node] = []

var current_state = player_states.MOVE
enum player_states {MOVE, ATTACK, DEAD}

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta;

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY;

	var direction := Input.get_axis("backward", "forward");
	if direction:
		velocity.x = direction * SPEED;
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED);
	
	if direction != 0:
		animations.flip_h = direction < 0
		
	update_animations()
	move_and_slide();
	

func set_current_attack(direction: String):
	current_attack = direction
	parry()
	
func parry():
	if current_attack == enemy.opposite_direction:
		enemy.health -= attack_damage;
		print("successful parry!")
		
func attack():
	if current_state == player_states.DEAD:
		return
	
	current_state = player_states.ATTACK
	hit_targets.clear()
	sword_hitbox.monitoring = true
	
	await get_tree().create_timer(attack_duration).timeout
	sword_hitbox.monitoring = false
	current_state = player_states.MOVE
	
	await get_tree().create_timer(attack_duration).timeout

func enemy_in_hitbox(area: Area2D):
	if current_state != player_states.ATTACK:
		return
	
	

func update_animations():
	if current_state != player_states.MOVE:
		return
	
	if !is_on_floor():
		if velocity.y < 0:
			animations.play("jump")
		else:
			animations.play("fall")
		
	elif velocity.x == 0:
		animations.play("idle")
	else:
		animations.play("walk")
		
	if current_state == player_states.ATTACK:
		if current_attack == "up":
			slash.play("slash_up");
		if current_attack == "down":
			slash.play("slash_down");
		if current_attack == "left":
			slash.play("slash_left");
		if current_attack == "right":
			slash.play("slash_right");
