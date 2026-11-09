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
	
func default_attack(attack_pattern: Array[String], attack_interval: float):
	
	timer.start()
	attacking = true;
	
	for direction in attack_pattern:
		current_attack = direction
		
	
