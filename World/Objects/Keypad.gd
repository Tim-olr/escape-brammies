extends Interactable
class_name Keypad

## Door node to unlock when the correct code is entered.
@export var door: Node = null

## The unlock code. Leave empty to auto-generate a random code.
@export var code: String = ""

## Length of the auto-generated code (ignored when code is set manually).
@export var code_length: int = 4

var _ui: KeypadUI
var _unlocked: bool = false

@onready var indicator: MeshInstance3D = $IndicatorLight

func _ready() -> void:
	goes_away_on_interact = false
	if code.is_empty():
		var n := ""
		for i in code_length:
			n += str(randi() % 10)
		code = n
	print("Keypad code: ", code)
	_ui = KeypadUI.new()
	add_child(_ui)

func interact() -> bool:
	if _unlocked:
		GlobalPlayer.promptinstance.show_prompt("Already unlocked.", 1.5)
		return false
	_ui.open(code, _on_correct_code)
	return false

func _on_correct_code() -> void:
	_unlocked = true
	# Turn indicator light green
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.1, 1.0, 0.1, 1)
	mat.emission_enabled = true
	mat.emission = Color(0.1, 1.0, 0.1, 1)
	mat.emission_energy_multiplier = 3.0
	indicator.set_surface_override_material(0, mat)
	# Unlock the door
	if door != null and "locked" in door:
		door.locked = false
	GlobalPlayer.promptinstance.show_prompt("Access granted!", 2.0)
