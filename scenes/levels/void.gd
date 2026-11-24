extends Area2D
@onready var timer := $Timer
@onready var player := $Player

# Called when the node enters the scene tree for the first time.
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("player in void")
		body.global_position = player.spawn
