extends Node2D

var line_position: PackedVector2Array = [] 
var currently_drawing: bool = false

signal drawing_done(direction: String)

func _unhandled_input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				currently_drawing = true;
				line_position.clear();
				line_position.append(get_local_mouse_position())
				queue_redraw();
			
			else:
				if currently_drawing:
					line_position.append(get_local_mouse_position());
					currently_drawing = false;
					
					var direction = attack_direction();
					
					print("attack: ", direction)
					
					drawing_done.emit(direction)
					queue_redraw()

	elif event is InputEventMouseMotion and currently_drawing:
		line_position.append(get_local_mouse_position());
		queue_redraw();

func _draw() -> void:
	if line_position.size() >= 2:
		draw_polyline(line_position, Color.WHITE, 3.0, true);

func attack_direction() -> String:

	if line_position.size() < 2:
		return "line too short";

	var movement = line_position[-1] - line_position[0]

	if movement.length() < 30:
		return "invalid direction";

	if abs(movement.x) > abs(movement.y):
	
		if movement.x > 0:
			return "right";
		else:
			return "left";

	else:

		if movement.y > 0:
			return "down";
		else:
			return "up";
