extends Node2D

@onready var camera_bounds_shape: CollisionShape2D = $CameraBounds/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_camera_bounds() -> Rect2:
	var shape := camera_bounds_shape.shape as RectangleShape2D
	var center := camera_bounds_shape.global_position
		
	return Rect2(center - shape.size / 2.0, shape.size)
	
