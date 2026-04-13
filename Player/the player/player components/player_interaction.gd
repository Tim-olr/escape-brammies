extends RayCast3D

var collider
var player_has_item_selected := false

func _ready() -> void:
	collide_with_areas = true

@onready var repair_ring: Node2D = $"../../CanvasLayer/Control/RepairRing"
@onready var hand: AnimatedSprite2D = $"../Hand"

func _process(_delta: float) -> void:
	if !player_has_item_selected:
		if get_collider() != null:
			if get_collider().has_method("can_interact"):
				show_interactable_visual()
				if Input.is_action_just_pressed("interact"):
					if get_collider().interact():
						grab_animation()
			else:
				hide_interaction_visual()
		else:
			hide_interaction_visual()

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
