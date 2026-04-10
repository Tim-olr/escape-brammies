extends Node

var exit;
var _continue;

func _ready() -> void:
	exit = get_node("Exit");
	_continue = get_node("Play");
	exit.pressed.connect(_on_Exit_pressed);
	_continue.pressed.connect(_on_Continue_pressed);
	$".".hide();

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			$".".show();
			get_tree().paused = true;
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_Continue_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$".".hide();
	get_tree().paused = false

func _on_Exit_pressed():
	get_tree().quit();
