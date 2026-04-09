extends RayCast3D

var collider
@onready var interaction_redicle: Sprite2D = $"../../CanvasLayer/Control/InteractionRedicle"
@onready var hand: AnimatedSprite2D = $"../Hand"

func _process(delta: float) -> void:
	if get_collider() != null:
		if get_collider().has_method("can_interact"):
			show_interactable_visual()
			if Input.is_action_just_pressed("interact"):
				get_collider().interact()
				grab_animation()
	else: hide_interaction_visual()

func hide_interaction_visual():
	interaction_redicle.hide()

func show_interactable_visual():
	interaction_redicle.show()
	
func grab_animation():
	hand.play("hand_grab")
	await hand.animation_finished
	hand.play("hand_idle")
