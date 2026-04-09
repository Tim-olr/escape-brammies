extends Node3D
class_name PlayerMovement

const ACCELERATION: float = 12.0
const FRICTION: float = 24.0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	GlobalPlayer.movement = self

func _physics_process(delta: float) -> void:
	var body: CharacterBody3D = GlobalPlayer.player
	var stats: PlayerStats    = GlobalPlayer.stats
	if not body or not stats:
		return

	_apply_gravity(body, delta)
	_handle_movement(body, stats, delta)
	body.move_and_slide()

func _apply_gravity(body: CharacterBody3D, delta: float) -> void:
	if not body.is_on_floor():
		body.velocity.y -= gravity * delta

func _handle_movement(body: CharacterBody3D, stats: PlayerStats, delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (body.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	var target_speed: float = stats.speed
	if Input.is_action_pressed("sprint"):
		target_speed *= stats.sprint_multiplier

	if direction:
		body.velocity.x = move_toward(body.velocity.x, direction.x * target_speed, ACCELERATION * delta)
		body.velocity.z = move_toward(body.velocity.z, direction.z * target_speed, ACCELERATION * delta)
	else:
		body.velocity.x = move_toward(body.velocity.x, 0.0, FRICTION * delta)
		body.velocity.z = move_toward(body.velocity.z, 0.0, FRICTION * delta)
