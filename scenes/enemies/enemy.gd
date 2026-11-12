extends CharacterBody2D
class_name Enemy

enum State{ ATTACKING, PARRIED, RESETTING, STUNNED, DEAD}

const SPEED = 300.0

@export var health := 10;
@export var attack_damage := 10;
var attack_pattern: Array[String] = ["up","down","left"]

@export var swing_duration := 2
@export var recovery_duration := 1
@export var parry_feedback_duration := 0.4
@export var reset_delay := 0.5
@export var stun_duration := 3.0

@onready var animations := $EnemyAnimations
@onready var enemy_sword: Area2D = $Sword
@onready var timer := $AttackCooldown


var state := State.ATTACKING

var pattern_index := 0
var current_attack := ""
var opposite_direction := ""

var sequence_id := 0
var swing_hit := false

func _ready() -> void:
	enemy_sword.monitoring = false
	enemy_sword.add_to_group("enemy_swords")
	
	enemy_sword.body_entered.connect(_on_sword_body_entered)
	
	start_attack_sequence()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta;
	
	move_and_slide();

func start_attack_sequence():
	if state == State.DEAD:
		return
	
	sequence_id += 1
	var current_sequence := sequence_id
	
	state = State.ATTACKING
	
	current_attack = attack_pattern[pattern_index]
	opposite_direction = get_opposite_direction(current_attack)
	
	run_attack_loop(current_sequence)

func run_attack_loop(id: int):
	while id == sequence_id and state == State.ATTACKING:
		
		swing_hit = false
		
		enemy_sword.monitoring = true
		animations.play(current_attack)
		
		await get_tree().create_timer(swing_duration).timeout
		
		if id != sequence_id or state != State.ATTACKING:
			return
		
		enemy_sword.monitoring = false
		animations.play("default")
		
		await get_tree().create_timer(recovery_duration).timeout
		
		if id != sequence_id or state != State.ATTACKING:
			return
			
		

func receive_parry(direction: String, player: Node):
	
	if state != State.ATTACKING or !enemy_sword.monitoring:
		return
	
	if direction == opposite_direction:
		successful_parry()
	else:
		reset_after_hit(player)
		

func successful_parry():
	sequence_id += 1
	enemy_sword.monitoring = false
	
	state = State.PARRIED
	animations.play("parried")
	print("parry successful!!")
	
	await get_tree().create_timer(parry_feedback_duration).timeout
	
	if state != State.PARRIED:
		return;
	
	pattern_index += 1
	
	if pattern_index >= attack_pattern.size():
		enter_stunned()
	else:
		start_attack_sequence()
	
func reset_after_hit(player: Node):
	
	if state != State.ATTACKING:
		return
		
	sequence_id += 1;
	state = State.RESETTING
	enemy_sword.monitoring = false
	
	player.take_damage(attack_damage)
	player.apply_knockback(global_position)
	await get_tree().create_timer(reset_delay).timeout

	if state != State.RESETTING:
		return
	
	pattern_index = 0
	start_attack_sequence()
	
func enter_stunned():
	sequence_id += 1
	state = State.STUNNED
	
	enemy_sword.monitoring = false
	animations.play("stunned")
	print("Enemy stunned!")
	
	await get_tree().create_timer(stun_duration).timeout
	
	if state != State.STUNNED:
		return
	
	pattern_index = 0
	start_attack_sequence()
	
func _on_sword_body_entered(body: Node2D):
	
	if state != State.ATTACKING || swing_hit:
		return
	
	if body.is_in_group("players"):
		swing_hit = true
		reset_after_hit(body)
		

func receive_player_attack(amount: int):
	if state != State.STUNNED:
		return
	
	take_damage(amount)
	
func take_damage(amount: int):
	if state == State.DEAD:
		return
	
	health -= amount
	
	if health <= 0:
		die()

func die():
	queue_free()

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
