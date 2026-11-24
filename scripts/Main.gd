extends Node2D

@export var starting_room: PackedScene
@export var spawn_path: NodePath = ^"PlayerSpawn"

@onready var player = $Player
@onready var camera = $Camera2D
@onready var room_container = $RoomContainer
@onready var fade = $CanvasLayer/ColorRect

var current_room: Node2D
var is_changing_room := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("rooms")
	player.add_to_group("player")
	fade.hide()
	fade.color.a = 0.0
	
	current_room = starting_room.instantiate()
	room_container.add_child(current_room)
	player.global_position = current_room.get_node_or_null(spawn_path).global_position
	
func change_room(room: PackedScene, spawn_path: NodePath, animate_camera:=true):
	if is_changing_room || room == null:
		return
	
	is_changing_room = true;
	await fade_in(0.5)
	
	var new_room := room.instantiate()
	room_container.add_child(new_room)
	
	var spawn = new_room.get_node_or_null(spawn_path);
	player.global_position = spawn.global_position
	
	var old_room = current_room
	current_room = new_room
	if old_room != null:
		old_room.queue_free()
	
	is_changing_room = false;
	player.current_state = player.player_states.MOVE
	fade_out(0.5)

func fade_in(duration: float):
	fade.show()
	
	var tween = create_tween()
	tween.tween_property(fade, "color:a", 1.0, duration)
	await tween.finished

func fade_out(duration: float):
	fade.show()
	
	var tween = create_tween()
	tween.tween_property(fade, "color:a", 0.0, duration)
	await tween.finished
