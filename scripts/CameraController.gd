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
	
	if animate: 
		
		transition_time_left = transition_duration
	else:
		transition_time_left = 0.0
		global_position = get_clamped_position(player.global_position)
		
	

func get_clamped_position(target: Vector2) -> Vector2:
	if current_room == null:
		return target
	
	var bounds: Rect2 = current_room.call("get_camera_bounds")
	var view_size = get_viewport_rect().size / zoom
	var half_view = view_size / 2.0
	
	if bounds.size.x <= view_size.x:
		target.x = bounds.position.x + bounds.size.x / 2.0
	else: 
		target.x = clampf( target.x, bounds.position.x + half_view.x, bounds.end.x - half_view.x)
	
	return target
	
	if bounds.size.y <= view_size.y:
		target.y = bounds.position.y + bounds.size.y / 2.0
	else: 
		target.y = clampf( target.y, bounds.position.y + half_view.y, bounds.end.y - half_view.y)
	
	return target

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var difference = player.global_position - global_position
	var half_zone = camera_deadzone / 2.0
	var target = player.global_position
	target = global_position
	
	if abs(difference.x) > half_zone.x:
		target.x += difference.x - sign(difference.x) * half_zone.x
		
	if abs(difference.y) > half_zone.y:
		target.y += difference.y - sign(difference.y) * half_zone.y
		
	target = get_clamped_position(target)
	
	var speed = follow_speed
	
	if transition_speed > 0:
		speed = transition_speed
		transition_time_left = maxf(transition_time_left - delta, 0.0)
	
	var weight = 1.0 - exp(-speed * delta)
	global_position = global_position.lerp(target, weight)
	
