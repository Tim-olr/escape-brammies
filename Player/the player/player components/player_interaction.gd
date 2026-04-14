extends RayCast3D

var player_has_item_selected := false

@onready var repair_ring: Node2D = $"../../CanvasLayer/Control/RepairRing"
@onready var hand: AnimatedSprite2D = $"../Hand"

func _ready() -> void:
	collide_with_areas = true
	collide_with_bodies = true

func _process(_delta: float) -> void:
	var hit = get_collider()
	if hit == null:
		hide_interaction_visual()
		return
		
	var interactable = find_interactable(hit)
	if interactable:
		show_interactable_visual()
		if Input.is_action_just_pressed("interact"):
			if interactable.interact():
				grab_animation()
	else:
		hide_interaction_visual()
		
func find_interactable(node: Node) -> Node:
	# Check de node zelf
	if node.has_method("can_interact"):
		return node
	# Check direct de parent, niet verder
	var parent = node.get_parent()
	if parent != null and parent.has_method("can_interact"):
		return parent
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
