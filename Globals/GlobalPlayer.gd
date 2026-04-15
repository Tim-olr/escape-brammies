extends Node

@onready var player: Player
@onready var stats: PlayerStats
@onready var movement: PlayerMovement
@onready var camera: PlayerCamera
@onready var inventory: PlayerInventory
@onready var interaction: RayCast3D
@onready var manager: PlayerManager
@onready var audio: PlayerAudio
@onready var promptinstance: CanvasLayer

var start_time: int

func start_timer():
	start_time = Time.get_ticks_msec()

func get_time() -> int:
	return Time.get_ticks_msec() - start_time
