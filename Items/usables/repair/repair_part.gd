extends UsableItem
class_name RepairPart

## Shared script for all draaideur repair items.
## Set part_id in the .tscn inspector: "motor", "wires", or "button".
@export var part_id: String = ""


func on_select() -> void:
	is_selected = true
	# slot.select() forces can_use=true; reset so _process controls it via raycast
	can_use = false


func _process(_delta: float) -> void:
	super._process(_delta)
	if is_selected:
		var collider = GlobalPlayer.interaction.get_collider()
		var aimed_at_door = (
			collider != null
			and collider.is_in_group("draaideur_repair")
			and _door_needs_this_part(collider)
		)
		can_use = aimed_at_door

		# Drive ring progress while holding the button
		if can_use and min_use_time > 0.0:
			GlobalPlayer.interaction.set_repair_progress(_hold_timer / min_use_time)
		else:
			GlobalPlayer.interaction.set_repair_progress(0.0)


func do_item_thing() -> void:
	var collider = GlobalPlayer.interaction.get_collider()
	if collider == null or not collider.is_in_group("draaideur_repair"):
		return
	var door = collider.get_parent()
	if door.install_part(part_id):
		GlobalPlayer.inventory.delete_item_from_current_slot()
		queue_free()



func _door_needs_this_part(collider: Node) -> bool:
	var door = collider.get_parent()
	return door.has_method("needs_part") and door.needs_part(part_id)
