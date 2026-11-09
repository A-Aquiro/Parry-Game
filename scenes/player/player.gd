extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -600.0
@export var health_points := 100;
@export var attack_damage := 10;
@onready var animations := $PlayerAnimations
@onready var slash := $Slashes
@onready var enemy := get_parent().get_node("TestEnemy")
var current_attack: String = "";

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

	move_and_slide();

func set_current_attack(direction: String):
	current_attack = direction
	parry()
	attack_animations()

func attack_animations():
	if current_attack == "up":
		slash.play("slash_up");
	if current_attack == "down":
		slash.play("slash_down");
	if current_attack == "left":
		slash.play("slash_left");
	if current_attack == "right":
		slash.play("slash_right");
	
func parry():
	if current_attack == enemy.opposite_direction:
		enemy.health -= attack_damage;
		print("successful parry!")
