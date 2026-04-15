extends Node3D
class_name FluorescentLight

var lights: Array = []
var tube_on: MeshInstance3D
var tube_off: MeshInstance3D

func _ready() -> void:
	tube_on  = get_node_or_null("TubeOn")
	tube_off = get_node_or_null("TubeOff")
	for child in get_children():
		if child is OmniLight3D:
			lights.append(child)
	add_to_group("powered_lights")
	_set_powered(false)

func turn_on() -> void:
	_flicker_on()

func turn_off() -> void:
	_set_powered(false)

func _set_powered(state: bool) -> void:
	for light in lights:
		light.visible = state
	if tube_on:  tube_on.visible  = state
	if tube_off: tube_off.visible = not state

func _flicker_on() -> void:
	for i in 10:
		var is_on := i % 2 == 0
		for light in lights:
			light.visible = is_on
		if tube_on:  tube_on.visible  = is_on
		if tube_off: tube_off.visible = not is_on
		await get_tree().create_timer(randf_range(0.04, 0.2)).timeout
	_set_powered(true)
