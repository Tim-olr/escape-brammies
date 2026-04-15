extends Node3D
class_name PlayerMovement

const ACCELERATION: float = 12.0
const FRICTION: float = 24.0
const COUNTER_STRAFE_MULTIPLIER: float = 4.0
const STAMINA_DRAIN_RATE: float = 20.0
const STAMINA_REGEN_RATE: float = 10.0
const FOV_DEFAULT: float = 75.0
const FOV_SPRINT_DELTA: float = 15.0
const FOV_TWEEN_SPEED: float = 0.2
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var stamina_bar: ProgressBar

@export var can_move: bool = true

var sprinting: bool = false
var _was_sprinting: bool = false
var can_sprint: bool = true
var style_box = StyleBoxFlat.new()
const COLOR_SPRINT := Color("d4a41dff")
const COLOR_REGEN  := Color("f4f8ffff")
const COLOR_EMPTY  := Color("c0392bff")
var _current_bar_color := Color("f4f8ffff")
var _tween: Tween
var _fov_tween: Tween
var _fov_target: float = FOV_DEFAULT  # tracks intended FOV, not mid-tween value

var has_had_sprint_penalty := false

func _ready() -> void:
	GlobalPlayer.movement = self
	style_box.set_corner_radius_all(5)
	style_box.bg_color = _current_bar_color
	stamina_bar.add_theme_stylebox_override("fill", style_box)
	if GlobalPlayer.camera:
		GlobalPlayer.camera.fov = FOV_DEFAULT

func _process(delta: float) -> void:
	var max_stamina: float = GlobalPlayer.stats.max_stamina
	stamina_bar.max_value = max_stamina
	stamina_bar.value = GlobalPlayer.stats.current_stamina
	if sprinting:
		if !has_had_sprint_penalty:
			GlobalPlayer.stats.current_stamina -= 5
			has_had_sprint_penalty = true
		GlobalPlayer.stats.current_stamina -= STAMINA_DRAIN_RATE * delta
		GlobalPlayer.stats.current_stamina = maxf(GlobalPlayer.stats.current_stamina, 0.0)
	else:
		if has_had_sprint_penalty:
			has_had_sprint_penalty = false
		GlobalPlayer.stats.current_stamina += STAMINA_REGEN_RATE * delta
		GlobalPlayer.stats.current_stamina = minf(GlobalPlayer.stats.current_stamina, max_stamina)
	if not can_sprint and GlobalPlayer.stats.current_stamina >= max_stamina * 0.25:
		can_sprint = true
	if GlobalPlayer.stats.current_stamina <= 0.0:
		can_sprint = false
	var target_color: Color
	if GlobalPlayer.stats.current_stamina <= 0.0:
		target_color = COLOR_EMPTY
	elif sprinting:
		target_color = COLOR_SPRINT
	else:
		target_color = COLOR_REGEN
	if target_color != _current_bar_color:
		_animate_to_color(target_color)
	if sprinting != _was_sprinting:
		_animate_fov(FOV_SPRINT_DELTA if sprinting else -FOV_SPRINT_DELTA)
		_was_sprinting = sprinting

func _animate_to_color(target: Color) -> void:
	_current_bar_color = target
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_method(_set_bar_color, style_box.bg_color, target, 0.35).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func _set_bar_color(color: Color) -> void:
	style_box.bg_color = color

func _animate_fov(fov_delta: float) -> void:
	if not GlobalPlayer.camera:
		return
	if _fov_tween:
		_fov_tween.kill()

	_fov_target += fov_delta  # update intended target, not current camera FOV
	_fov_tween = create_tween()
	_fov_tween.tween_property(GlobalPlayer.camera, "fov", _fov_target, FOV_TWEEN_SPEED).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

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
	if can_move:
		var input_dir := Input.get_vector("left", "right", "up", "down")
		var direction := (body.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		var carrying_heavy := GlobalPlayer.inventory != null and GlobalPlayer.inventory.has_repair_part()
		var wants_sprint := Input.is_action_pressed("sprint") and direction != Vector3.ZERO
		sprinting = wants_sprint and can_sprint and not carrying_heavy
		var target_speed: float = stats.speed
		if carrying_heavy:
			target_speed *= 0.75
		if sprinting:
			target_speed *= stats.sprint_multiplier
		if direction:
			var accel_x := ACCELERATION
			var accel_z := ACCELERATION
			if sign(direction.x) != 0.0 and sign(direction.x) != sign(body.velocity.x) and abs(body.velocity.x) > 0.1:
				accel_x *= COUNTER_STRAFE_MULTIPLIER
			if sign(direction.z) != 0.0 and sign(direction.z) != sign(body.velocity.z) and abs(body.velocity.z) > 0.1:
				accel_z *= COUNTER_STRAFE_MULTIPLIER
			body.velocity.x = move_toward(body.velocity.x, direction.x * target_speed, accel_x * delta)
			body.velocity.z = move_toward(body.velocity.z, direction.z * target_speed, accel_z * delta)
		else:
			body.velocity.x = move_toward(body.velocity.x, 0.0, FRICTION * delta)
			body.velocity.z = move_toward(body.velocity.z, 0.0, FRICTION * delta)
