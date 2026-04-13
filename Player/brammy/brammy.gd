extends CharacterBody3D

@export var speed := 3.5;
@export var attack_range := 1.5;
@export var attack_damage := 10;
@export var health := 100;

var player : CharacterBody3D = null;
const Gravity = -9.8;

@onready var nav_agent := $NavigationAgent3D;
enum State { IDLE, PATROL, CHASE, ATTACK };
var state = State.PATROL;

func _ready():
	player = GlobalPlayer.player;

func _update_path():
	if player:
		nav_agent.target_position = player.global_position;

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += Gravity * delta

	if player == null:
		return

	if global_position.distance_to(player.global_position) < 10.0:
		state = State.CHASE;

	if global_position.distance_to(player.global_position) <= attack_range:
		state = State.ATTACK;

	match state: 
		State.IDLE:
			move_toward_player(0.0);
		State.PATROL:
			pass
		State.CHASE:
			move_toward_player(5.0);
		State.ATTACK:
			attack();


func attack():
	return

func move_toward_player(speed: float):
	_update_path();
	
	if not nav_agent.is_navigation_finished():
		var next_pos = nav_agent.get_next_path_position();
		var direction = (next_pos - global_position);
		
		velocity.x = direction.x * speed;
		velocity.y = direction.y * speed;
		
		look_at(Vector3(next_pos.x, global_position.y, next_pos.z));
	else:
		velocity.x = 0;
		velocity.y = 0;
		
	move_and_slide();
