extends Camera2D

@export var follow_speed := 5.0
@export var transition_speed := 5.0
@export var transition_duration := 0.5;
@export var camera_deadzone := Vector2(180, 100);

var player: Node2D
var current_room: Node2D

var transition_time_left := 0.0

func setup(target_player: Node2D):
	player = target_player
	make_current()
	

func set_room(room: Node2D, animate := true):
	current_room = room
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
