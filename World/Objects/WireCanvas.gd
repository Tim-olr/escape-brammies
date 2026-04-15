extends Control
class_name WireCanvas

const COLORS: Array[Color] = [
	Color(1.0, 0.2, 0.2),   # red
	Color(1.0, 0.85, 0.1),  # yellow
	Color(0.2, 0.5, 1.0),   # blue
]
const NODE_RADIUS := 16.0
const WIRE_WIDTH  := 4.0

## right_order[i] = which left color index appears at right position i
var right_order: Array[int] = [0, 1, 2]
## connections[left_idx] = right_idx the player connected it to
var connections: Dictionary = {}
var dragging_from: int = -1
var mouse_pos: Vector2 = Vector2.ZERO

signal completed

func _draw() -> void:
	var lp := _left_pos()
	var rp := _right_pos()

	# Side wire stubs
	for i in 3:
		draw_line(Vector2(0, lp[i].y), lp[i], COLORS[i], WIRE_WIDTH)
		draw_line(rp[i], Vector2(size.x, rp[i].y), COLORS[right_order[i]], WIRE_WIDTH)

	# Completed connections
	for left_idx: int in connections:
		var right_idx: int = connections[left_idx]
		draw_line(lp[left_idx], rp[right_idx], COLORS[left_idx], WIRE_WIDTH)

	# In-progress drag (dashed)
	if dragging_from >= 0:
		_draw_dashed(lp[dragging_from], mouse_pos, COLORS[dragging_from])

	# Left nodes
	for i in 3:
		draw_circle(lp[i], NODE_RADIUS, COLORS[i])
		draw_arc(lp[i], NODE_RADIUS, 0, TAU, 32, Color.WHITE, 2.0)

	# Right nodes
	for i in 3:
		draw_circle(rp[i], NODE_RADIUS, COLORS[right_order[i]])
		draw_arc(rp[i], NODE_RADIUS, 0, TAU, 32, Color.WHITE, 2.0)

func _gui_input(event: InputEvent) -> void:
	var lp := _left_pos()
	var rp := _right_pos()

	if event is InputEventMouseMotion:
		mouse_pos = event.position
		if dragging_from >= 0:
			queue_redraw()

	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			for i in 3:
				if event.position.distance_to(lp[i]) <= NODE_RADIUS + 6.0:
					dragging_from = i
					mouse_pos = event.position
					connections.erase(i)
					queue_redraw()
					return
		else:
			if dragging_from >= 0:
				for i in 3:
					if event.position.distance_to(rp[i]) <= NODE_RADIUS + 6.0:
						connections[dragging_from] = i
						dragging_from = -1
						queue_redraw()
						_check_complete()
						return
				dragging_from = -1
				queue_redraw()

func _check_complete() -> void:
	if connections.size() < 3:
		return
	for left_idx: int in connections:
		var right_idx: int = connections[left_idx]
		if right_order[right_idx] != left_idx:
			return
	completed.emit()

func _left_pos() -> Array[Vector2]:
	var out: Array[Vector2] = []
	for i in 3:
		out.append(Vector2(NODE_RADIUS + 2.0, size.y * (i + 1) / 4.0))
	return out

func _right_pos() -> Array[Vector2]:
	var out: Array[Vector2] = []
	for i in 3:
		out.append(Vector2(size.x - NODE_RADIUS - 2.0, size.y * (i + 1) / 4.0))
	return out

func _draw_dashed(from: Vector2, to: Vector2, color: Color) -> void:
	var dir := (to - from)
	var length := dir.length()
	if length < 0.001:
		return
	dir = dir / length
	var dash := 10.0
	var gap  := 6.0
	var t    := 0.0
	while t < length:
		var a := from + dir * t
		var b := from + dir * minf(t + dash, length)
		draw_line(a, b, color, WIRE_WIDTH - 1.0)
		t += dash + gap
