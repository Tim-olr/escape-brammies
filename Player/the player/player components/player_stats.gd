extends Node3D
class_name PlayerStats

@export var speed: float = 5.0
@export var task_time: float = 2.0
@export var sprint_multiplier: float = 2.0
@export var look_speed: float = 0.002 

func _ready() -> void:
	GlobalPlayer.stats = self
