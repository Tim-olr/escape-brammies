extends CharacterBody3D
class_name enemy
@export var wanderingSpeed: float
@export var chaseSpeed: float
@export var accel: float
@export var nav: NavigationAgent3D
@export var PlayerCast: RayCast3D
@export var PlayerArea: Area3D
@export var interaction_timer: Timer
@export var attention_area: Area3D
@export var started: bool = false

var can_open_door: bool = true
var speed
var target
var phase = 1
var attentionTimer: Timer
var difficulty = 1
var main_parent
var possies
var has_collided: bool = false
var can_check: bool = false

func _ready() -> void:
	main_parent = get_parent()
	possies = main_parent.possies
	attentionTimer = Timer.new()
	attentionTimer.autostart = false
	attentionTimer.one_shot = true
	attentionTimer.timeout.connect(loseAttention)
	add_child(attentionTimer)
	target = possies.get_random_pos()
	await get_tree().process_frame
	PlayerCast.enabled = true

func _process(delta: float) -> void:
	for p in PlayerArea.get_overlapping_bodies():
		if p.is_in_group("player"):
			p.manager.die()

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	if started:
		if phase == 3:
			speed = chaseSpeed
			target = GlobalPlayer.player
		else:
			if PlayerCast.is_colliding() and PlayerCast.get_collider().is_in_group("player"):
				has_collided = true
				phase = 2
				target = GlobalPlayer.player
			elif can_check:
				phase = 2
				target = GlobalPlayer.player
			if phase == 2:
				speed = chaseSpeed
			elif phase == 1:
				speed = wanderingSpeed
				if global_position.distance_to(target.global_position) < 3:
					target = possies.get_random_pos()
		if is_instance_valid(target):
			nav.target_position = target.global_position if not target is Vector3 else target
		var direction = (nav.get_next_path_position() - global_position).normalized()
		velocity.x = lerp(velocity.x, direction.x * speed, accel * delta)
		velocity.z = lerp(velocity.z, direction.z * speed, accel * delta)
		var horizontal_velocity = Vector3(velocity.x, 0, velocity.z)
		if horizontal_velocity.length() > 0.01:
			look_at(global_position + horizontal_velocity, Vector3.UP)
		move_and_slide()

func loseAttention():
	target = possies.get_random_pos()
	can_check = false
	has_collided = false
	phase = 1

func _on_player_attention_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		loseAttention()

func _on_player_attention_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and has_collided:
		can_check = true
