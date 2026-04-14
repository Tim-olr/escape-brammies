extends Node3D

@export var possies: Node3D

func _ready() -> void:
	GlobalRefs.world_positions = possies
