extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -600.0
@export var health := 100;
@export var attack := 10;
@onready var animations := $PlayerAnimations
@onready var timer := $AttackCooldown
var current_attack := "";
var opposite_attack := "";

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta;

	move_and_slide();

func _ready() -> void:
	

func attack_pattern():	
	timer.start()
	current_attack = "up";
	await get_tree().create_timer(1000).timeout;
	current_attack = "down";
	await get_tree().create_timer(1000).timeout;
	current_attack = "right";
	await get_tree().create_timer(1000).timeout;

func set_opposite_attack():
	if current_attack == "up":
		opposite_attack = "down"
	if current_attack == "down":
		opposite_attack = "up"
	if current_attack == "left":
		opposite_attack = "right"
	if current_attack == "right":
		opposite_attack = "left"
