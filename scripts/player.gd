extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -600.0
@export var health := 100;
@export var attack := 10;
@onready var animations := $PlayerAnimations

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("backward", "forward")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
