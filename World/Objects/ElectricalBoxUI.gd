extends CanvasLayer
class_name ElectricalBoxUI

var _canvas: WireCanvas
var _callback: Callable

func _ready() -> void:
	layer = 10
	visible = false
	_build_ui()

	func _build_ui() -> void:
		var bg := ColorRect.new()
		bg.color = Color(0, 0, 0, 0.65)
		bg.set_anchors_preset(Control.PRESET_FULL_RECT)
		add_child(bg)

		var center := CenterContainer.new()
		center.set_anchors_preset(Control.PRESET_FULL_RECT)
		add_child(center)

		var panel := PanelContainer.new()
		panel.custom_minimum_size = Vector2(440, 0)
		center.add_child(panel)

		var margin := MarginContainer.new()
		for side in ["left", "right", "top", "bottom"]:
			margin.add_theme_constant_override("margin_" + side, 18)
			panel.add_child(margin)

			var vbox := VBoxContainer.new()
			vbox.add_theme_constant_override("separation", 12)
			margin.add_child(vbox)

			var title := Label.new()
			title.text = "Fix Wiring"
			title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			title.add_theme_font_size_override("font_size", 16)
			vbox.add_child(title)

			_canvas = WireCanvas.new()
			_canvas.custom_minimum_size = Vector2(400, 240)
			_canvas.mouse_filter = Control.MOUSE_FILTER_STOP
			_canvas.completed.connect(_on_complete)
			# Redraw whenever the layout gives us a real size
			_canvas.item_rect_changed.connect(_canvas.queue_redraw)
			vbox.add_child(_canvas)

			var hint := Label.new()
			hint.text = "[ESC] Cancel"
			hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			hint.add_theme_font_size_override("font_size", 11)
			hint.modulate = Color(1, 1, 1, 0.45)
			vbox.add_child(hint)


			func open(callback: Callable) -> void:
				_callback = callback
				_canvas.connections.clear()
				_canvas.dragging_from = -1
				var order: Array[int] = [0, 1, 2]
				order.shuffle()
				_canvas.right_order = order
				visible = true
				# Defer redraw so layout has run and canvas has its real size
				_canvas.call_deferred("queue_redraw")
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				GlobalPlayer.movement.can_move = false
				GlobalPlayer.camera.can_look = false

				func close() -> void:
					visible = false
					Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
					GlobalPlayer.movement.can_move = true
					GlobalPlayer.camera.can_look = true

					func _on_complete() -> void:
						var sfx := load("res://assets/models/scalda/Electric SHOCK.mp3")
						if sfx:
						GlobalPlayer.audio.set_stream_and_audio(sfx, 0)
						GlobalPlayer.audio.play()
						_callback.call()
						close()

						func _unhandled_input(event: InputEvent) -> void:
							if not visible:
							return
							if event is InputEventKey and event.pressed and not event.echo:
								if event.keycode == KEY_ESCAPE:
									close()
									get_viewport().set_input_as_handled()
func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0, 0, 0, 0.65)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(440, 0)
	center.add_child(panel)

	var margin := MarginContainer.new()
	for side in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 18)
	panel.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	margin.add_child(vbox)

	var title := Label.new()
	title.text = "Fix Wiring"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 16)
	vbox.add_child(title)

	_canvas = WireCanvas.new()
	_canvas.custom_minimum_size = Vector2(400, 240)
	_canvas.mouse_filter = Control.MOUSE_FILTER_STOP
	_canvas.completed.connect(_on_complete)
	# Redraw whenever the layout gives us a real size
	_canvas.item_rect_changed.connect(_canvas.queue_redraw)
	vbox.add_child(_canvas)

	var hint := Label.new()
	hint.text = "[ESC] Cancel"
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_font_size_override("font_size", 11)
	hint.modulate = Color(1, 1, 1, 0.45)
	vbox.add_child(hint)


func open(callback: Callable) -> void:
	_callback = callback
	_canvas.connections.clear()
	_canvas.dragging_from = -1
	var order: Array[int] = [0, 1, 2]
	order.shuffle()
	_canvas.right_order = order
	visible = true
	# Defer redraw so layout has run and canvas has its real size
	_canvas.call_deferred("queue_redraw")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	GlobalPlayer.movement.can_move = false
	GlobalPlayer.camera.can_look = false

func close() -> void:
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GlobalPlayer.movement.can_move = true
	GlobalPlayer.camera.can_look = true

func _on_complete() -> void:
	var sfx := load("res://assets/models/scalda/Electric SHOCK.mp3")
	if sfx:
		GlobalPlayer.audio.set_stream_and_audio(sfx, 0)
		GlobalPlayer.audio.play()
	_callback.call()
	close()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			close()
			get_viewport().set_input_as_handled()
