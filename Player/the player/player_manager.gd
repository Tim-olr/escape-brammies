extends Node3D
class_name PlayerManager
var is_paused: bool = false
@onready var paused_timer: Timer = $"../PausedTimer"
@onready var gray: TextureRect = $"../CanvasLayer/grayscale"
@onready var ap: AnimationPlayer = $"../AnimationPlayer"
@onready var sprite_3d: Sprite3D = $"../Sprite3D"

var can_sql: bool = true

func _ready() -> void:
	sprite_3d.visible = false
	GlobalPlayer.manager = self

func calculate_drop_height():
	var pos = GlobalPlayer.player.global_position
	var ground_pos = GlobalPlayer.player.global_position.y / 2
	pos.y = ground_pos
	return pos

func pause_everything_except_player():
	if !is_paused:
		show_gray()
		GlobalRefs.pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS
		GlobalPlayer.player.process_mode = Node.PROCESS_MODE_ALWAYS
		is_paused = true
		paused_timer.start(GlobalPlayer.stats.pause_time)
		get_tree().paused = true

func unpause_everything():
	if is_paused:
		hide_gray()
		is_paused = false
		get_tree().paused = false
		can_sql = true
		GlobalPlayer.player.process_mode = Node.PROCESS_MODE_INHERIT

func _on_paused_timer_timeout() -> void:
	unpause_everything()

func show_gray(duration: float = 0.5) -> void:
	var tw = create_tween()
	tw.tween_property(gray.material, "shader_parameter/saturation", 0.0, duration) \
	  .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func hide_gray(duration: float = 0.5) -> void:
	var tw = create_tween()
	tw.tween_property(gray.material, "shader_parameter/saturation", 1.0, duration) \
	  .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func die():
	GlobalPlayer.movement.can_move = false
	GlobalPlayer.camera.can_look = false
	GlobalPlayer.player.global_position = GlobalPlayer.player.death_pos.global_position
	GlobalRefs.brammy.hide()
	ap.speed_scale = 1.5
	ap.play("jumpscare")

func move_to_menu():
	get_tree().change_scene_to_file("res://assets/UI/MainMenu.tscn")
