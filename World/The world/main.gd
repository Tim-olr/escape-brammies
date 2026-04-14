extends Node3D

@export var possies: Node3D
@export var bin: Bin
@export var game_started: bool = false
@export var brammy: enemy

func _ready() -> void:
	GlobalRefs.world_positions = possies

func _on_start_sequence_detection_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and !game_started:
		game_started = true
		bin.ap.play("bram_pop_out")
		brammy.started = true
		GlobalPlayer.camera.fov = 32.0

func _on_start_sequence_detection_body_exited(body: Node3D) -> void:
	if body.is_in_group("player") and game_started:
		GlobalPlayer.camera.fov = 75.0
		bin.ap.play("bram_in")
