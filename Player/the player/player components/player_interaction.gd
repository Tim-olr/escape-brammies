extends RayCast3D

var player_has_item_selected := false

@onready var repair_ring: Node2D = $"../../CanvasLayer/Control/RepairRing"
@onready var hand: AnimatedSprite2D = $"../Hand"

func _ready() -> void:
	collide_with_areas = true
	collide_with_bodies = true

func _process(_delta: float) -> void:
	var interactable = _find_interactable()
	if interactable:
		show_interactable_visual()
		if Input.is_action_just_pressed("interact"):
			if interactable.interact():
				grab_animation()
	else:
		hide_interaction_visual()

const RAYCAST_IGNORE := ["BigRoundTable"]

## Cast the ray, skipping nodes in RAYCAST_IGNORE so items placed on them are reachable.
func _find_interactable() -> Node:
	var space := get_world_3d().direct_space_state
	var ray_end := global_position + global_transform.basis * target_position
	var exclude: Array[RID] = []
	for _i in 8:
		var query := PhysicsRayQueryParameters3D.create(global_position, ray_end)
		query.exclude = exclude
		query.collide_with_areas = true
		query.collide_with_bodies = true
		var result := space.intersect_ray(query)
		if result.is_empty():
			return null
		var hit: Node = result["collider"]
		var interactable := find_interactable(hit)
		if interactable:
			return interactable
		if _is_ignored(hit):
			exclude.append(result["rid"])
			continue
		return null
	return null

func _is_ignored(node: Node) -> bool:
	var n := node
	while n != null:
		if n.name in RAYCAST_IGNORE:
			return true
		n = n.get_parent()
	return false

func find_interactable(node: Node) -> Node:
	# Check de node zelf
	if node.has_method("can_interact"):
		return node
	# Check direct de parent, niet verder
	var parent = node.get_parent()
	if parent != null and parent.has_method("can_interact"):
		return parent
	if parent.has_method("hello_area"):
		return parent.area
	return null

func hide_interaction_visual() -> void:
	repair_ring.hide_ring()
func show_interactable_visual() -> void:
	repair_ring.show_ring()
func set_repair_progress(value: float) -> void:
	repair_ring.set_progress(value)
func grab_animation() -> void:
	hand.play("hand_grab")
	await hand.animation_finished
	hand.play("hand_idle")
