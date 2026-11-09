extends Node2D
@onready var player = $Player;
@onready var player_attack = $Attack;
@onready var enemy = $TestEnemy;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_attack.drawing_done.connect(player.set_current_attack)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
