extends Control
const KIDS_SAYING_YAY_SOUND_EFFECT_3 = preload("uid://nlurqgn7wopu")

@onready var menu: Button = $Menu
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var time_actual: RichTextLabel = $TimeActual


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var finishtime = GlobalPlayer.get_time();
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	audio_stream_player_2d.play()
	menu.pressed.connect(go_to_menu)
	time_actual.append_text(format_time(finishtime))
	pass # Replace with function body.

func go_to_menu() -> void:
	get_tree().change_scene_to_file("res://assets/UI/MainMenu.tscn")

func format_time(ms: int) -> String:
	var minutes = ms / 60000
	var seconds = (ms / 1000) % 60
	var milliseconds = ms % 1000

	return "%02d:%02d.%03d" % [minutes, seconds, milliseconds]
