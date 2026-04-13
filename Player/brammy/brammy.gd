extends CharacterBody3D

@export var speed := 3.5
@export var attack_range := 1.5
@export var attack_damage := 10
@export var health := 100

var player: CharacterBody3D = null
const GRAVITY = -9.8

@onready var nav_agent := $NavigationAgent3D

enum State { IDLE, PATROL, CHASE, ATTACK }
var state = State.CHASE

func _ready():
	player = GlobalPlayer.player
	
	await NavigationServer3D.map_changed
	await get_tree().physics_frame
	
	#debugging
	var map = nav_agent.get_navigation_map()
	var closest_to_enemy = NavigationServer3D.map_get_closest_point(map, global_position)
	var closest_to_player = NavigationServer3D.map_get_closest_point(map, player.global_position)

	print("Enemy pos: ", global_position)
	print("Closest navmesh point to enemy: ", closest_to_enemy)
	print("Player pos: ", player.global_position)
	print("Closest navmesh point to player: ", closest_to_player)
	###
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.2
	timer.timeout.connect(_update_path)
	timer.start()

func _update_path():
	if player:
		nav_agent.target_position = player.global_position

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if player == null:
		return

	var dist = global_position.distance_to(player.global_position)

	if dist > attack_range:
		state = State.CHASE
	if dist <= attack_range:
		state = State.ATTACK

	match state:
		State.IDLE:
			move_toward_player(0.0)
		State.PATROL:
			move_toward_player(3.0)
		State.CHASE:
			move_toward_player(5.0)
		State.ATTACK:
			attack()
			move_and_slide()

func attack():
	pass

func move_toward_player(move_speed: float):
	if not nav_agent.is_target_reachable():
		print("not reachable")
		return
		
	if not nav_agent.is_navigation_finished():
		var next_pos = nav_agent.get_next_path_position()
		var direction = (next_pos - global_position)
		direction = direction.normalized()
		print(direction);
		
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
		
		look_at(Vector3(next_pos.x, global_position.y, next_pos.z))
	else:
		velocity.x = 0
		velocity.z = 0
	
	move_and_slide()
