extends Node3D
class_name PlayerInventory
@export var hotbar: HBoxContainer
@export var slot_1: InventorySlot
@export var slot_2: InventorySlot
@export var slot_3: InventorySlot
@export var hand: AnimatedSprite2D
var current_item
var current_slot: InventorySlot
func _ready():
	GlobalPlayer.inventory = self
func _process(delta: float) -> void:
	if Input.is_action_pressed("use_item"):
		if current_item:
			current_item.use(delta)
	elif Input.is_action_just_released("use_item"):
		if current_item:
			current_item.cancel_use()
	if Input.is_action_just_pressed("drop"):
		drop_item()
	if Input.is_action_just_pressed("hotbar_1"):
		select_slot(slot_1)
	elif Input.is_action_just_pressed("hotbar_2"):
		select_slot(slot_2)
	elif Input.is_action_just_pressed("hotbar_3"):
		select_slot(slot_3)
func select_slot(slot: InventorySlot) -> void:
	if current_slot:
		current_slot.deselect()
		set_slot_outline(current_slot, 0.0)
	current_slot = slot
	current_slot.select()
	set_slot_outline(current_slot, 1.5)
	current_item = current_slot.held_item
	GlobalPlayer.interaction.player_has_item_selected = current_item != null
func set_slot_outline(slot: InventorySlot, thickness: float) -> void:
	var sprite = slot.slot_sprite
	sprite.material.set_shader_parameter("outline_thickness", thickness)
func add_item(item):
	var index = 1
	for i in hotbar.get_children():
		if !check_occupied_slot(index):
			if item != null:
				var slot = get_slot(index)
				slot.held_item = item
				slot.has_item = true
				slot.slot_sprite.texture = item.custom_texture
				slot.slot_item.add_child(item)
				return true
		index += 1
		if check_inv_full():
			return false
func get_slot(slot_number):
	match slot_number:
		1: return slot_1
		2: return slot_2
		3: return slot_3
func check_occupied_slot(slot: int) -> bool:
	match slot:
		1: return slot_1.has_item
		2: return slot_2.has_item
		3: return slot_3.has_item
	return true
func check_inv_full() -> bool:
	if slot_1.has_item and slot_2.has_item and slot_3.has_item:
		return true
	else:
		return false
func drop_item():
	if current_slot and current_slot.selected:
		if current_item:
			current_item.drop()
			drop_item_animation()
			delete_item_from_current_slot()
func delete_item_from_current_slot():
	current_slot.deselect()
	set_slot_outline(current_slot, 0.0)
	current_slot.held_item = null
	current_slot.slot_sprite.texture = null
	current_slot.has_item = false
	current_item = null
	GlobalPlayer.interaction.player_has_item_selected = false
func drop_item_animation():
	hand.play("hand_drop")
	await hand.animation_finished
	hand.play("hand_idle")
