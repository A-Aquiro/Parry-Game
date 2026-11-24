extends Area2D

@export var destination_room: PackedScene
@export var spawn_path: NodePath = ^"PlayerSpawn"

var activated := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	

func _on_body_entered(body):
	print("go to next room")
	
	if body.is_in_group("player"):
		body.current_state = body.player_states.TRANSITION
		body.player_anim.play("idle")
		
		var main = get_tree().get_first_node_in_group("rooms")
		main.call("change_room", destination_room, spawn_path, true);
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
