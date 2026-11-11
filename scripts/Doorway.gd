extends Area2D

@export var destination_room: PackedScene
@export var destination_spawn_path: NodePath

var activated := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	

func _on_body_entered(body):
	var room_manager = get_tree().get_first_node_in_group("room_manager")
	room_manager.call("change_room", destination_room, destination_spawn_path, true);
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
