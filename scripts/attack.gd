extends Node2D

var _click_pos: Array = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		return
	
	_click_pos.append(event.position);

func _draw() -> void:
	for point in _click_pos:
		draw_circle(point, 10, Color.WHITE)
