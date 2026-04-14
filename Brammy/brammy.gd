extends CharacterBody3D
class_name enemy

@export var wanderingSpeed: float
@export var chaseSpeed: float
@export var accel: float
@export var nav: NavigationAgent3D
@export var PlayerCast: RayCast3D
@export var PlayerArea: Area3D

var speed
var target
var phase = 1
var attentionTimer: Timer
var difficulty = 1

var main_parent
var possies

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
		if p.is_in_group("door"):
			p.get_parent().get_parent().get_parent().interact()

func _physics_process(delta):
	var direction = Vector3()
	if phase == 3:
		speed = chaseSpeed
		target = GlobalPlayer.player
	else:
		PlayerCast.look_at(GlobalPlayer.player.global_position)
		if PlayerCast.is_colliding():
			if PlayerCast.get_collider().is_in_group("player"):
				if phase == 1:
					target = possies.get_random_pos()
				phase = 2
		if phase == 1:
			speed = wanderingSpeed
			if global_position.distance_to(target.global_position) < 3:
				target = possies.get_random_pos()
		if phase == 2:
			speed = chaseSpeed
			target = GlobalPlayer.player

	nav.target_position = target.global_position

	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()

	velocity = velocity.lerp(direction * speed, accel * delta)

	if velocity.length() > 0.01:
		look_at(global_position + velocity, Vector3.UP)

	move_and_slide()

func loseAttention():
	target = possies.get_random_pos()
	phase = 1
