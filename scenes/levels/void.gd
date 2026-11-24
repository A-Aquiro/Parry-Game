extends Area2D
@onready var timer := $Timer
@onready var player := $Player

func _ready() -> void:
	body_entered.connect(_on_body_entered)
# Called when the node enters the scene tree for the first time.

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.current_state = body.player_states.TRANSITION
		print("player in void")
		body.player_anim.play("death")
		
		var main = get_tree().get_first_node_in_group("rooms")
		await main.call("fade_in", 0.2)
		
		body.current_state = body.player_states.DEAD
		main.call("fade_out", 0.2)
