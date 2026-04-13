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


func drop() -> void:
	var path := "res://Items/interactables/repair_pickups/%s_pickup.tscn" % part_id
	var scene: PackedScene = load(path)
	if scene == null:
		push_error("RepairPart: failed to load pickup scene: " + path)
		return
	var spawn := scene.instantiate()
	GlobalPlayer.player.get_parent().add_child(spawn)
	# Place 1.2m in front of the player, then raycast down to snap to ground
	var player: CharacterBody3D = GlobalPlayer.player
	var forward := -player.transform.basis.z.normalized()
	var drop_pos: Vector3 = player.global_position + forward * 1.2

	var space := player.get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(drop_pos, drop_pos + Vector3.DOWN * 10.0)
	query.exclude = [player.get_rid()]
	var hit := space.intersect_ray(query)
	if hit:
		drop_pos = hit.position + Vector3.UP * 0.2
	spawn.global_position = drop_pos

func _door_needs_this_part(collider: Node) -> bool:
	var door = collider.get_parent()
	return door.has_method("needs_part") and door.needs_part(part_id)
