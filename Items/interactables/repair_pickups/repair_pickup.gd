extends Interactable
class_name RepairPickup

## Generic world pickup for repair items.
## Set item_scene in the inspector to the matching repair .tscn.
@export var item_scene: PackedScene

func can_interact():
	GlobalPlayer.inventory.drop_item()
	pass

func interact() -> bool:
	if item_scene == null:
		return false
	var item = item_scene.instantiate()
	if GlobalPlayer.inventory.add_item(item):
		check_go_away()
		return true
	item.queue_free()
	return false
