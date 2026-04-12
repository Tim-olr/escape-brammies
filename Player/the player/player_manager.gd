extends Node3D
class_name PlayerManager

func _ready() -> void:
	GlobalPlayer.manager = self

func calculate_drop_height():
	var pos = GlobalPlayer.player.global_position
	var ground_pos = GlobalPlayer.player.global_position.y / 2
	pos.y = ground_pos
	return pos
