extends Camera2D 

@onready var player = $"../Player" 

func _ready():
	position_smoothing_enabled = true
	position_smoothing_speed = 5.0

func _process(delta):
	global_position = player.global_position
	
func camera_panning():
	position = player.position
	var x = floor(position.x / 120) * 120
	var y = floor(position.y / 120) * 100
	 
	position = Vector2(x,y)
	
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", Vector2(x,y), 0.14)

func camera_follow():
	anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER
	position = player.position
