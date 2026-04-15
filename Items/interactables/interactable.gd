extends Area3D
class_name Interactable

@export var goes_away_on_interact: bool = true

func _ready() -> void:
	add_to_group("interactable")

func can_interact():
	pass

func interact() -> bool:
	return false

func check_go_away():
	if goes_away_on_interact:
		queue_free()
