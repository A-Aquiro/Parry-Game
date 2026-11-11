extends Node2D

@export var starting_room: PackedScene
@export var starting_spawn_path: NodePath = ^"PlayerSpawn"

@onready var player = $Player
@onready var camera = $Camera2D
@onready var room_container = $RoomContainer

var current_room: Node2D
var is_changing_room := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("rooms")
	player.add_to_group("player")
	
	camera.call("setup", player)
	
	change_room(starting_room, starting_spawn_path, false)

func change_room(room: PackedScene, spawn_path: NodePath, animate_camera:=true):
	if is_changing_room || room == null:
		return
	
	is_changing_room = true;
	
	var new_room = room.instantiate();
	
	room_container.add_child(new_room)
	
	var spawn = new_room.get_node_or_null(spawn_path);
	
	if(spawn == null):
		print("no spawn in " + str(spawn_path))
		new_room.queue_free()
		is_changing_room = false
		return
	
	player.global_position = spawn.global_position
	
	var old_room = current_room
	current_room = new_room
	
	camera.call("set_room", new_room, animate_camera)
	
	if old_room != null:
		old_room.queue_free()
	
	is_changing_room = false;
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
