extends Node3D
class_name MainScene

@export var possies: Node3D
@export var bin: Bin
@export var game_started: bool = false
@export var brammy: enemy
@export var brammy_spawn_possies: Node3D
@export var world_en: WorldEnvironment
@onready var breaker_pos: Marker3D = $breaker_pos
@onready var interactable_spawn_locations: Node3D = $"Interactable spawn locations"

@export var interactables: Array[PackedScene]

var has_walked: bool = false
var fov_tween: Tween

func _ready() -> void:
	GlobalRefs.world_positions = possies
	GlobalRefs.breaker_pos = breaker_pos
	GlobalRefs.main = self
	spawn_random_inter()
	GlobalRefs.breaker.begin_light_on()


func lerp_fov(target: float, duration: float = 0.6) -> void:
	if fov_tween:
		fov_tween.kill()
	fov_tween = create_tween()
	fov_tween.tween_property(GlobalPlayer.camera, "fov", target, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _on_start_sequence_detection_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and !game_started:
		game_started = true
		bin.ap.play("bram_pop_out")
		bin.audio.play()
		GlobalRefs.brammy.footsteps.play()
		GlobalRefs.breaker.begin_light_off()
		brammy.started = true
		var rand_pos = brammy_spawn_possies.get_children().pick_random()
		brammy.global_position = rand_pos.global_position
		lerp_fov(32.0)
		GlobalPlayer.promptinstance.show_prompt("BRAMMY HAS AWOKEN")

func _on_start_sequence_detection_body_exited(body: Node3D) -> void:
	if body.is_in_group("player") and game_started and !has_walked:
		lerp_fov(75.0)
		bin.ap.play("bram_in")
		has_walked = true

func spawn_random_inter():
	for i in interactable_spawn_locations.get_children():
		var rng = randi_range(0, 1)
		if rng == 0:
			var interactable = interactables.pick_random()
			var int_scene = interactable.instantiate()
			add_child(int_scene)
			int_scene.global_position = i.global_position
