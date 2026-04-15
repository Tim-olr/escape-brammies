extends Node

var play;
var exit;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	play = get_node("Play");
	exit = get_node("Exit");
	play.pressed.connect(_on_Play_pressed);
	exit.pressed.connect(_on_Exit_pressed);



func _on_Play_pressed():
	get_tree().change_scene_to_file("res://World/The world/main.tscn")

func _on_Settings_pressed():
	pass

func _on_Exit_pressed():
	get_tree().quit();
