extends Interactable
class_name BreakerBox

signal power_restored
signal power_cut

const HOLD_TIME := 5.0

var _power_on := false
var _hold_timer := 0.0

@onready var handle: Node3D = $Handle
@onready var power_light_on: MeshInstance3D = $PowerLightOn
@onready var power_light_off: MeshInstance3D = $PowerLightOff

func _ready() -> void:
	handle.rotation_degrees.z = 50.0  # start in "off" position (leaning left)
	power_light_on.visible = false
	power_light_off.visible = true

func can_interact() -> void:
	pass

# Hold-based — handled in _process, not via instant interact()
func interact() -> bool:
	return false

func _process(delta: float) -> void:
	var collider = GlobalPlayer.interaction.get_collider()
	var aimed := _is_aimed_at(collider)

	if aimed and Input.is_action_pressed("interact"):
		_hold_timer += delta
		GlobalPlayer.interaction.set_repair_progress(_hold_timer / HOLD_TIME)
		if _hold_timer >= HOLD_TIME:
			_hold_timer = 0.0
			GlobalPlayer.interaction.set_repair_progress(0.0)
			_toggle_power()
	else:
		if _hold_timer > 0.0:
			_hold_timer = 0.0
			GlobalPlayer.interaction.set_repair_progress(0.0)

func _toggle_power() -> void:
	_power_on = not _power_on


	var target_angle := deg_to_rad(-50.0) if _power_on else deg_to_rad(50.0)
	var tween := create_tween()
	tween.tween_property(handle, "rotation:z", target_angle, 0.35).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

	power_light_on.visible = _power_on
	power_light_off.visible = not _power_on

	for light in get_tree().get_nodes_in_group("powered_lights"):
		if _power_on:
			light.turn_on()
		else:
			light.turn_off()

	if _power_on:
		power_restored.emit()
		GlobalPlayer.promptinstance.show_prompt("Power restored!", 3.0)
	else:
		power_cut.emit()
		GlobalPlayer.promptinstance.show_prompt("Power cut.", 3.0)

func _is_aimed_at(collider) -> bool:
	if collider == null:
		return false
	var node = collider
	while node != null:
		if node == self:
			return true
		node = node.get_parent()
	return false

func power_off():
	GlobalPlayer.audio.set_stream_and_audio(preload("uid://cu6jpka2p7xbb"), 0)
	GlobalPlayer.audio.play()
