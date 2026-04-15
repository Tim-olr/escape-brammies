extends AudioStreamPlayer3D

@export var audios: Array[AudioStream]
@onready var timer: Timer = $Timer

func _ready() -> void:
	audio_proc()

func choose_random_audio():
	return audios.pick_random()

func audio_proc():
	var rand_sec = randf_range(15, 40)
	timer.start(rand_sec)

func _on_timer_timeout() -> void:
	if GlobalRefs.brammy.started:
		stream = choose_random_audio()
		play()
	audio_proc()
