class_name Enemy
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -600.0
@export var health := 100;
@export var attack := 10;
@onready var animations := $EnemyAnimations
@onready var timer := $AttackCooldown
var current_attack := "";
var opposite_direction := "";
var attacking := false;
var defaultAttackPattern: Array[String] = ["up","down","left"]

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta;
	
	move_and_slide();

func _process(delta: float) -> void:
	if attacking == false:
		animations.play("default")

func _ready() -> void:
	default_attack(defaultAttackPattern, 1)
	
func default_attack(attack_pattern: Array[String], attack_time: float):
	
	timer.start()
	attacking = true;
	
	for direction in attack_pattern:
		current_attack = direction
		opposite_direction = get_opposite_direction(direction)
		
		animations.play(direction)
		print("required direction to parry:" + opposite_direction)
		
		get_tree().create_timer(attack_time).timeout
		
	attacking = false;
	
func get_opposite_direction(direction: String) -> String:
	
	if direction == "up":
		return "down";
	elif direction == "down":
		return "up";
	elif direction == "left":
		return "right";
	elif direction == "right":
		return "left";
	else:
		return "error"
