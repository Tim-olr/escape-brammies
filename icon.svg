extends Node3D
class_name PlayerCamera

var _pitch: float = 0.0
const PITCH_LIMIT: float = 1.5

@export var bob_speed: float = 8.0
@export var bob_amount: float = 20.0

@onready var sprite: AnimatedSprite2D = $Hand

var _bob_time: float = 0.0
var _sprite_origin: Vector2

func _ready() -> void:
	GlobalPlayer.camera = self
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_sprite_origin = sprite.position

func _process(delta: float) -> void:
	_update_bob(delta)

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

# Ik heb dit van iemand gestolen, vraag me niet hoe het werk -jeroen
func _update_bob(delta: float) -> void:
	var body: CharacterBody3D = GlobalPlayer.player
	if not body:
		return

	var horizontal_vel := Vector2(body.velocity.x, body.velocity.z).length()
	var is_moving := horizontal_vel > 0.5

	if is_moving:
		_bob_time += delta * bob_speed
		sprite.position = _sprite_origin + Vector2(
			sin(_bob_time) * bob_amount,
			abs(sin(_bob_time)) * bob_amount
		)
	else:
		_bob_time = lerp(_bob_time, 0.0, delta * 10.0)
		sprite.position = sprite.position.lerp(_sprite_origin, delta * 10.0)
