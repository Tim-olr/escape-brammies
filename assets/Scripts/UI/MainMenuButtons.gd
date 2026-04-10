extends Node

var play;
var settings;
var exit;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play = get_node("Play");
	settings = get_node("Settings");
	exit = get_node("Exit");
	print("{0} {1} {2}".format([play, settings, exit]));
	play.pressed.connect(_on_Play_pressed);
	settings.pressed.connect(_on_Settings_pressed);
	exit.pressed.connect(_on_Exit_pressed);



func _on_Play_pressed():
	get_tree().change_scene_to_file("res://World/The world/main.tscn")

func _on_Settings_pressed():
	pass

func _on_Exit_pressed():
	get_tree().quit();
