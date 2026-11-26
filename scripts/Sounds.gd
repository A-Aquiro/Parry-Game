extends Node
var active_sounds: Array = []

var sfx_library: Dictionary = {
	"slash": preload("res://sounds/slash.ogg")
}

var music_player: AudioStreamPlayer

func _ready() -> void:
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.autoplay = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_SFX(sound: String, volume: int):
	print("playing sound ", sound)
	var soundPlayer: AudioStreamPlayer = AudioStreamPlayer.new()
	add_child(soundPlayer)
	
	soundPlayer.stream = sfx_library[sound]
	soundPlayer.volume_db = volume
	soundPlayer.bus = "Master"
	soundPlayer.play()
	
	var duration := soundPlayer.stream.get_length()
	
	var timer: Timer = Timer.new()
	timer.wait_time = duration
	timer.one_shot = true;
	timer.autostart = true
	add_child(timer)
	timer.timeout.connect(Callable(self, "_remove_and_free_player").bind(soundPlayer))
	

func _remove_and_free_player(player: AudioStreamPlayer) -> void:
	if active_sounds.has(player):
		active_sounds.erase(player)
	if is_instance_valid(player):
		player.queue_free()


#func play_BGM(sound: String, volume: int):
	
