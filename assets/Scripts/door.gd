extends Interactable
@export var openOtherWay: bool = false;
@export var locked: bool = false;
@onready var door: Node3D = $blockbench_export/door

var tween_door: Tween
var opened: bool = false
var initial_rotation: float

func _ready() -> void:
	super()
	opened = false
	initial_rotation = door.rotation_degrees.y

func interact() -> bool:
	if !locked:
		opened = !opened
		var openDegrees = (90.0 if !openOtherWay else -90.0)
		var target = (initial_rotation + openDegrees) if opened else initial_rotation
		tweenDoor(door, tween_door, target)
	else:
		GlobalPlayer.promptinstance.show_prompt("This door is locked")
	return true

func tweenDoor(d: Node3D, tween: Tween, targetDegrees: float) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(
		d,
		"rotation_degrees:y",
		targetDegrees,
		0.5
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
