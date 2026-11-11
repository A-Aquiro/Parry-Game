extends Node2D

@export var camera_bounds := Rect2(0, 0, 1280, 720)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_camera_bounds() -> Rect2:
	var top_left = to_global(camera_bounds.position)
	var bottom_right = to_global(camera_bounds.position + camera_bounds.size)
	
	return Rect2(top_left, bottom_right - top_left)
	
