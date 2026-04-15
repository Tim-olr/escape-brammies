extends Interactable
class_name HardcoreModeInteractable

const STAMINA_REGEN_RATE: float = 10.0

@export var speed_multiplier: float = 1.25
@export var stamina_capacity_multiplier: float = 0.6666667
@export var stamina_regen_penalty_ratio: float = 0.33
@onready var sprite_3d: Sprite3D = $Sprite3D

var _is_active: bool = false
var _base_brammy_wandering_speed: float = 0.0
var _base_brammy_chase_speed: float = 0.0
var _base_max_stamina: float = 0.0

func _process(delta: float) -> void:
	if not _is_active:
		return
	_apply_stamina_regen_penalty(delta)
	_enforce_single_item_inventory()

func interact() -> bool:
	if GlobalPlayer.stats == null or GlobalPlayer.inventory == null:
		return false
	if GlobalRefs.brammy != null and GlobalRefs.brammy.started:
		return false

	if _is_active:
		_disable_hardcore_mode()
		return true

	_base_max_stamina = GlobalPlayer.stats.max_stamina
	if GlobalRefs.brammy != null:
		_base_brammy_wandering_speed = GlobalRefs.brammy.wanderingSpeed
		_base_brammy_chase_speed = GlobalRefs.brammy.chaseSpeed
	_is_active = true

	if GlobalRefs.brammy != null:
		GlobalRefs.brammy.wanderingSpeed = _base_brammy_wandering_speed * speed_multiplier
		GlobalRefs.brammy.chaseSpeed = _base_brammy_chase_speed * speed_multiplier
	GlobalPlayer.stats.max_stamina = _base_max_stamina * stamina_capacity_multiplier
	GlobalPlayer.stats.current_stamina = minf(GlobalPlayer.stats.current_stamina, GlobalPlayer.stats.max_stamina)

	_enforce_single_item_inventory()
	sprite_3d.texture = preload("uid://fssd6g317lpe")
	return true

func _apply_stamina_regen_penalty(delta: float) -> void:
	if GlobalPlayer.stats == null or GlobalPlayer.movement == null:
		return
	if GlobalPlayer.movement.sprinting:
		return

	var regen_penalty := STAMINA_REGEN_RATE * stamina_regen_penalty_ratio * delta
	GlobalPlayer.stats.current_stamina -= regen_penalty
	GlobalPlayer.stats.current_stamina = clampf(
		GlobalPlayer.stats.current_stamina,
		0.0,
		GlobalPlayer.stats.max_stamina
	)

func _enforce_single_item_inventory() -> void:
	var inventory: PlayerInventory = GlobalPlayer.inventory
	if inventory == null:
		return

	_drop_and_clear_slot(inventory.slot_1)
	_drop_and_clear_slot(inventory.slot_3)

	inventory.slot_1.visible = false
	inventory.slot_3.visible = false
	inventory.slot_1.disabled = true
	inventory.slot_3.disabled = true
	inventory.slot_1.has_item = true
	inventory.slot_3.has_item = true

	if inventory.current_slot == inventory.slot_1 or inventory.current_slot == inventory.slot_3:
		inventory.select_slot(inventory.slot_2)

func _drop_and_clear_slot(slot: InventorySlot) -> void:
	if slot == null:
		return
	if slot.held_item != null:
		slot.held_item.drop()
		if slot.held_item.get_parent() != null:
			slot.held_item.get_parent().remove_child(slot.held_item)
		slot.held_item.queue_free()
	slot.held_item = null
	slot.slot_sprite.texture = null
	slot.has_item = false

func _disable_hardcore_mode() -> void:
	sprite_3d.texture = preload("uid://busjg1flw41f8")
	_is_active = false
	if GlobalRefs.brammy != null:
		GlobalRefs.brammy.wanderingSpeed = _base_brammy_wandering_speed
		GlobalRefs.brammy.chaseSpeed = _base_brammy_chase_speed
	GlobalPlayer.stats.max_stamina = _base_max_stamina
	GlobalPlayer.stats.current_stamina = minf(GlobalPlayer.stats.current_stamina, GlobalPlayer.stats.max_stamina)

	var inventory: PlayerInventory = GlobalPlayer.inventory
	if inventory == null:
		return

	inventory.slot_1.visible = true
	inventory.slot_3.visible = true
	inventory.slot_1.disabled = false
	inventory.slot_3.disabled = false
	inventory.slot_1.has_item = inventory.slot_1.held_item != null
	inventory.slot_3.has_item = inventory.slot_3.held_item != null
