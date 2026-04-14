extends Interactable

@export var openOtherWay: bool = false
@export var locked: bool = false

@onready var door_1: Node3D = $blockbench_export/Door1
@onready var door_2: Node3D = $blockbench_export/Doo2
@onready var interaction_1: CollisionShape3D = $Interaction1
@onready var interaction_2: CollisionShape3D = $Interaction2

var tween_door_1: Tween
var tween_door_2: Tween
var opened: bool = false

var initial_rotation_1: float
var initial_rotation_2: float
var initial_collision_1: float
var initial_collision_2: float

func _ready() -> void:
	opened = false
	initial_rotation_1 = door_1.rotation_degrees.y
	initial_rotation_2 = door_2.rotation_degrees.y
	initial_collision_1 = interaction_1.rotation.y
	initial_collision_2 = interaction_2.rotation.y

func interact() -> bool:
	if !locked:
		opened = !opened
		var openDegrees = (90.0 if !openOtherWay else -90.0)
		animateDoors(openDegrees)
	else:
		GlobalPlayer.promptinstance.show_prompt("This door is locked")
	return true

func animateDoors(openDegrees: float) -> void:
	var target_1 = (initial_rotation_1 + openDegrees) if opened else initial_rotation_1
	var target_2 = (initial_rotation_2 - openDegrees) if opened else initial_rotation_2
	tweenDoor(door_1, tween_door_1, target_1, interaction_1, initial_collision_1, openDegrees)
	tweenDoor(door_2, tween_door_2, target_2, interaction_2, initial_collision_2, -openDegrees)

func tweenDoor(door: Node3D, tween: Tween, targetDegrees: float, collision: CollisionShape3D, initial_col: float, openDegrees: float) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	
	tween.tween_property(
		door,
		"rotation_degrees:y",
		targetDegrees,
		0.5
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	
	var target_col = (initial_col + deg_to_rad(openDegrees)) if opened else initial_col
	tween.parallel().tween_property(
		collision,
		"rotation:y",
		target_col,
		0.5
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
