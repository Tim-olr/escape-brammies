extends VBoxContainer

@onready var motor_label:         Label = $MotorLabel
@onready var wires_label:         Label = $WiresLabel
@onready var button_label:        Label = $ButtonLabel
@onready var restore_power_label: Label = $RestorePowerLabel
@onready var escape_label:        Label = $EscapeLabel

const DONE := "[x] "
const TODO := "[ ] "
const COLOR_DONE   := Color(0.45, 1.0, 0.45)
const COLOR_TODO   := Color(1.0, 1.0, 1.0, 0.85)
const COLOR_ESCAPE := Color(1.0, 0.85, 0.2)

enum Stage { REPAIR, RESTORE_POWER, ESCAPE }

func _process(_delta: float) -> void:
	match _get_stage():
		Stage.REPAIR:
			motor_label.visible         = true
			wires_label.visible         = true
			button_label.visible        = true
			restore_power_label.visible = false
			escape_label.visible        = false
			_update("Motor",  motor_label)
			_update("Wires",  wires_label)
			_update("Button", button_label)
		Stage.RESTORE_POWER:
			motor_label.visible         = false
			wires_label.visible         = false
			button_label.visible        = false
			restore_power_label.visible = true
			escape_label.visible        = false
			restore_power_label.text    = TODO + "Restore power"
			restore_power_label.modulate = COLOR_TODO
		Stage.ESCAPE:
			motor_label.visible         = false
			wires_label.visible         = false
			button_label.visible        = false
			restore_power_label.visible = false
			escape_label.visible        = true
			escape_label.text           = ">>> Escape! <<<"
			escape_label.modulate       = COLOR_ESCAPE

func _get_stage() -> Stage:
	var door := get_tree().get_first_node_in_group("draaideur")
	var door_repaired: bool = door != null \
		and not door.needs_part("motor") \
		and not door.needs_part("wires") \
		and not door.needs_part("button")
	if not door_repaired:
		return Stage.REPAIR
	var breaker := get_tree().get_first_node_in_group("breaker_box") as BreakerBox
	if breaker == null or not breaker.power_on:
		return Stage.RESTORE_POWER
	return Stage.ESCAPE

func _update(item_name: String, label: Label) -> void:
	var done := _is_installed(item_name)
	label.text     = (DONE if done else TODO) + "Repair the " + item_name
	label.modulate = COLOR_DONE if done else COLOR_TODO

func _is_installed(item_name: String) -> bool:
	var door := get_tree().get_first_node_in_group("draaideur")
	if door and door.has_method("needs_part"):
		return not door.needs_part(item_name.to_lower())
	return false
