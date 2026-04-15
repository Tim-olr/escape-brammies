extends Interactable
@export var openOtherWay: bool = false;
@export var locked: bool = false;
@onready var door_1: Node3D = $blockbench_export/Door1
@onready var doo_2: Node3D = $blockbench_export/Doo2
var tween_door_1: Tween
var tween_door_2: Tween
var opened: bool = false
var initial_rotation_1: float
var initial_rotation_2: float

func _ready() -> void:
	opened = false
	initial_rotation_1 = door_1.rotation_degrees.y
	initial_rotation_2 = doo_2.rotation_degrees.y

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
	var target_2 = (initial_rotation_2 - openDegrees) if opened else initial_rotation_2  # tegenovergesteld!
	tweenDoor(door_1, tween_door_1, target_1)
	tweenDoor(doo_2, tween_door_2, target_2)

func tweenDoor(door: Node3D, tween: Tween, targetDegrees: float) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(
		door,
		"rotation_degrees:y",
		targetDegrees,
		0.5
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
