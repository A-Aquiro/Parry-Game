extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
@export var health_points := 100;

@onready var animations := $PlayerAnimations
@onready var slash := $Slashes 
@onready var sword_hitbox := $Sword

var hit_targets: Array[Node] = []

var current_state = player_states.MOVE
enum player_states {MOVE, DEAD}


func _ready():
	sword_hitbox.monitoring = false
	sword_hitbox.area_entered.connect(enemy_in_hitbox)
	
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

func attack():
	if current_state == player_states.DEAD:
		return
	
	current_state = player_states.ATTACK
	hit_targets.clear()
	sword_hitbox.monitoring = true
	
	await get_tree().create_timer(attack_duration).timeout
	sword_hitbox.monitoring = false
	current_state = player_states.ATTACK_COOLDOWN
	
	await get_tree().create_timer(attack_duration).timeout
	
	current_state = player_states.MOVE
	
func enemy_in_hitbox(area: Area2D):
	if current_state != player_states.ATTACK:
		return
	
	var target = area.get_parent()
	
	if target == null or hit_targets.has(target):
		return
	
	hit_targets.append(target)
	
	if target.has_method("take_damage"):
		target.take_damage(attack_damage)

func set_current_attack(direction: String):
	attack_direction = direction
	attack()
	
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
	
