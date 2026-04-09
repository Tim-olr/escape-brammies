extends Button
class_name InventorySlot

var held_item
var selected: bool

func _process(delta: float) -> void:
	if selected:
		pass

func select():
	if held_item != null:
		selected = true
		held_item.can_use = true
		GlobalPlayer.inventory.current_item = held_item

func deselect():
	selected = false
	if held_item != null:
		held_item.can_use = false
		GlobalPlayer.inventory.current_item = held_item
