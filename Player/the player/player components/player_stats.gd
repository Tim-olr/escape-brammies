extends Node3D
class_name PlayerStats

@export var speed: float = 5.0
@export var task_time: float = 2.0
@export var sprint_multiplier: float = 1.25
@export var look_speed: float = 0.002 
@export var max_stamina: float = 100.0
@export var pause_time: float = 5.0
var current_stamina: float

func _ready() -> void:
	GlobalPlayer.stats = self
	current_stamina = max_stamina
