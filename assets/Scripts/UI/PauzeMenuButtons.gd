extends Node
var exit
var _continue
func _ready() -> void:
	GlobalRefs.pause_menu = get_parent()
	process_mode = Node.PROCESS_MODE_ALWAYS
	exit = get_node("Exit")
	_continue = get_node("Play")
	exit.pressed.connect(_on_Exit_pressed)
	_continue.pressed.connect(_on_Continue_pressed)
	$".".hide()
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			$".".show()
			GlobalPlayer.player.process_mode = Node.PROCESS_MODE_INHERIT
			get_tree().paused = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_Continue_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$".".hide()
	get_tree().paused = false
	if GlobalPlayer.manager.is_paused:
		GlobalPlayer.player.process_mode = Node.PROCESS_MODE_ALWAYS
	else:
		GlobalPlayer.player.process_mode = Node.PROCESS_MODE_INHERIT
func _on_Exit_pressed():
	get_tree().quit()
