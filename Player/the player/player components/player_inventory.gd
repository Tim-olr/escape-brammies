extends Node3D
class_name PlayerInventory

@export var hotbar: HBoxContainer
@export var slot_1: InventorySlot
@export var slot_2: InventorySlot
@export var slot_3: InventorySlot

var current_item
var current_slot: InventorySlot

func _process(delta: float) -> void:
	if Input.is_action_pressed("use_item"):
		if current_item:
			current_item.use(delta)
	elif Input.is_action_just_released("use_item"):
		if current_item:
			current_item.cancel_use()

	if Input.is_action_just_pressed("hotbar_1"):
		select_slot(slot_1)
	elif Input.is_action_just_pressed("hotbar_2"):
		select_slot(slot_2)
	elif Input.is_action_just_pressed("hotbar_3"):
		select_slot(slot_3)

func select_slot(slot: InventorySlot) -> void:
	if current_slot:
		current_slot.deselect()
	current_slot = slot
	current_slot.select()
	current_item = current_slot.held_item
