extends Node3D
class_name PositionNode

var positions: Array

func _ready() -> void:
	positions = get_all_pos()

func get_all_pos():
	return get_children()

func get_random_pos():
	var pos = get_all_pos().pick_random()
	return pos
