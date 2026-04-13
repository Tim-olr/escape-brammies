extends Node2D

## Circular progress ring drawn at screen centre.
## Shows as a faint halo when an interaction is available,
## fills clockwise as the player holds the use button.

const RADIUS     := 20.0
const BG_WIDTH   := 2.0
const ARC_WIDTH  := 4.5
const SEGMENTS   := 64

var _progress: float = 0.0
var _ring_visible: bool = false


func show_ring() -> void:
	_ring_visible = true
	queue_redraw()


func hide_ring() -> void:
	_ring_visible = false
	_progress = 0.0
	queue_redraw()


func set_progress(value: float) -> void:
	_progress = clampf(value, 0.0, 1.0)
	queue_redraw()


func _draw() -> void:
	if not _ring_visible:
		return

	# Faint background ring so the player always sees the full circle outline
	draw_arc(Vector2.ZERO, RADIUS, 0.0, TAU, SEGMENTS,
			Color(1, 1, 1, 0.25), BG_WIDTH, true)

	# White fill arc from the top (-PI/2), clockwise
	if _progress > 0.001:
		var sweep := TAU * _progress
		var pts   := maxi(2, int(SEGMENTS * _progress) + 1)
		draw_arc(Vector2.ZERO, RADIUS,
				-PI * 0.5, -PI * 0.5 + sweep,
				pts, Color(1, 1, 1, 1.0), ARC_WIDTH, true)

	# Tiny centre dot so it doubles as a crosshair
	draw_circle(Vector2.ZERO, 2.0, Color(1, 1, 1, 0.85))
