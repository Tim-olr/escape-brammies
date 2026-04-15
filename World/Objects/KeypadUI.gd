extends CanvasLayer
class_name KeypadUI

var _correct_code: String = ""
var _entered: String = ""
var _callback: Callable
var _locked_out: bool = false

var _display: Label
var _status: Label

func _ready() -> void:
	layer = 10
	visible = false
	_build_ui()

func _build_ui() -> void:
	# Dim background
	var bg := ColorRect.new()
	bg.color = Color(0, 0, 0, 0.6)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	# Centered panel
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(230, 0)
	center.add_child(panel)

	var margin := MarginContainer.new()
	for side in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 16)
	panel.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	margin.add_child(vbox)

	# Title
	var title := Label.new()
	title.text = "— KEYPAD —"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 14)
	vbox.add_child(title)

	# Code display
	_display = Label.new()
	_display.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_display.add_theme_font_size_override("font_size", 32)
	vbox.add_child(_display)

	# Status line
	_status = Label.new()
	_status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_status.add_theme_font_size_override("font_size", 13)
	_status.custom_minimum_size = Vector2(0, 20)
	vbox.add_child(_status)

	# Button grid  (1 2 3 / 4 5 6 / 7 8 9 / ← 0 ✓)
	var grid := GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 6)
	grid.add_theme_constant_override("v_separation", 6)
	vbox.add_child(grid)

	for label in ["1","2","3","4","5","6","7","8","9","←","0","✓"]:
		var btn := Button.new()
		btn.text = label
		btn.custom_minimum_size = Vector2(58, 46)
		btn.add_theme_font_size_override("font_size", 18)
		btn.pressed.connect(_press.bind(label))
		grid.add_child(btn)

	# Cancel hint
	var hint := Label.new()
	hint.text = "[ESC] Cancel"
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_font_size_override("font_size", 11)
	hint.modulate = Color(1, 1, 1, 0.45)
	vbox.add_child(hint)

func open(code: String, callback: Callable) -> void:
	_correct_code = code
	_entered = ""
	_callback = callback
	_locked_out = false
	_status.text = ""
	_status.modulate = Color(1, 1, 1)
	_update_display()
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	GlobalPlayer.movement.can_move = false
	GlobalPlayer.camera.can_look = false

func close() -> void:
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GlobalPlayer.movement.can_move = true
	GlobalPlayer.camera.can_look = true

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	match event.keycode:
		KEY_ESCAPE:
			close()
		KEY_BACKSPACE:
			_press("←")
		KEY_ENTER, KEY_KP_ENTER:
			_press("✓")
		KEY_0, KEY_KP_0: _press("0")
		KEY_1, KEY_KP_1: _press("1")
		KEY_2, KEY_KP_2: _press("2")
		KEY_3, KEY_KP_3: _press("3")
		KEY_4, KEY_KP_4: _press("4")
		KEY_5, KEY_KP_5: _press("5")
		KEY_6, KEY_KP_6: _press("6")
		KEY_7, KEY_KP_7: _press("7")
		KEY_8, KEY_KP_8: _press("8")
		KEY_9, KEY_KP_9: _press("9")
	get_viewport().set_input_as_handled()

func _press(val: String) -> void:
	if _locked_out or not visible:
		return
	match val:
		"←":
			if _entered.length() > 0:
				_entered = _entered.left(_entered.length() - 1)
			_update_display()
		"✓":
			_check_code()
		_:
			if _entered.length() < _correct_code.length():
				_entered += val
			_update_display()

func _check_code() -> void:
	if _entered == _correct_code:
		_status.text = "ACCESS GRANTED"
		_status.modulate = Color(0.2, 1.0, 0.3)
		_locked_out = true
		_callback.call()
		get_tree().create_timer(1.2).timeout.connect(close)
	else:
		_status.text = "WRONG CODE"
		_status.modulate = Color(1.0, 0.25, 0.25)
		_locked_out = true
		_entered = ""
		_update_display()
		await get_tree().create_timer(1.0).timeout
		if visible:
			_status.text = ""
			_locked_out = false

func _update_display() -> void:
	var shown := ""
	for i in _correct_code.length():
		shown += ("*" if i < _entered.length() else "_")
	_display.text = shown
