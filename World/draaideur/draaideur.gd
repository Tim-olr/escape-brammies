extends Node3D

## Revolving door (draaideur).
## Broken by default — install motor, wires, and button to repair it.
## Once repaired, spins when a body enters the trigger zone.

signal repaired

@export var rotation_speed: float = 120.0   ## degrees per second at full speed
@export var acceleration: float = 80.0      ## degrees/sec² ramp-up
@export var deceleration: float = 60.0      ## degrees/sec² ramp-down

var _current_speed: float = 0.0
var _bodies_inside: int = 0
var _is_repaired: bool = false

var player_nearby: bool:
	get: return _bodies_inside > 0

var _parts: Dictionary = {
	"motor": false,
	"wires": false,
	"button": false,
}

@onready var rotating_part: AnimatableBody3D = $RotatingPart
@onready var trigger_zone: Area3D = $TriggerZone
@onready var repair_zone: Area3D = $RepairZone


func _ready() -> void:
	trigger_zone.body_entered.connect(_on_body_entered)
	trigger_zone.body_exited.connect(_on_body_exited)
	add_to_group("draaideur")
	repair_zone.add_to_group("draaideur_repair")


func _physics_process(delta: float) -> void:
	if not _is_repaired:
		return
	var target := rotation_speed if _bodies_inside > 0 else 0.0
	var rate := acceleration if _bodies_inside > 0 else deceleration
	_current_speed = move_toward(_current_speed, target, rate * delta)
	if abs(_current_speed) > 0.01:
		rotating_part.rotate_y(deg_to_rad(_current_speed) * delta)


## Called by RepairPart items. Returns true if the part was accepted.
func install_part(part_id: String) -> bool:
	if not _parts.has(part_id):
		return false
	if _parts[part_id]:
		return false  # already installed
	_parts[part_id] = true
	print("Draaideur: installed ", part_id)
	_check_repaired()
	return true


## Returns true if this part still needs to be installed.
func needs_part(part_id: String) -> bool:
	return _parts.has(part_id) and not _parts[part_id]


func _check_repaired() -> void:
	if _parts["motor"] and _parts["wires"] and _parts["button"]:
		_is_repaired = true
		print("Draaideur: fully repaired!")
		emit_signal("repaired")


func _on_body_entered(_body: Node3D) -> void:
	_bodies_inside += 1


func _on_body_exited(_body: Node3D) -> void:
	_bodies_inside = max(0, _bodies_inside - 1)
