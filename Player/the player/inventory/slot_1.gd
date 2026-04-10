extends Button
class_name InventorySlot

var held_item
var selected: bool
var has_item := false
@export var slot_item: Node3D
@export var slot_sprite: Sprite2D

func _process(delta: float) -> void:
	if selected:
		pass

func select():
	if held_item != null:
		selected = true
		held_item.can_use = true
		GlobalPlayer.interaction.player_has_item_selected = true
		GlobalPlayer.inventory.current_item = held_item
		held_item.on_select()

func deselect():
	if held_item != null:
		selected = false
		held_item.can_use = false
		GlobalPlayer.interaction.player_has_item_selected = false
		GlobalPlayer.inventory.current_item = held_item
		held_item.on_deselect()
