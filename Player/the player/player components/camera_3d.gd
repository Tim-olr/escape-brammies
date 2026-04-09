extends Node3D
class_name PlayerCamera

var _pitch: float = 0.0
const PITCH_LIMIT: float = 1.5

func _ready() -> void:
	GlobalPlayer.camera = self
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_rotate_camera(event.relative)

	if event.is_action_pressed("ui_cancel"):
		var mode := Input.MOUSE_MODE_VISIBLE \
			if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED \
			else Input.MOUSE_MODE_CAPTURED
		Input.set_mouse_mode(mode)

func _rotate_camera(mouse_delta: Vector2) -> void:
	var stats: PlayerStats = GlobalPlayer.stats
	var body: CharacterBody3D = GlobalPlayer.player
	if not stats or not body:
		return

	var sensitivity: float = stats.look_speed

	body.rotate_y(-mouse_delta.x * sensitivity)

	_pitch -= mouse_delta.y * sensitivity
	_pitch = clamp(_pitch, -PITCH_LIMIT, PITCH_LIMIT)
	rotation.x = _pitch
