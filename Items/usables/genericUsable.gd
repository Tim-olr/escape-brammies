extends Node
class_name UsableItem

@export_category("info")
@export var item_name: String
@export var min_use_time: float = 0.0 # laat deze op 0.0 als het een insta use is
@export var custom_texture: Texture2D # Kan niet null zijn pls
@export var model: PackedScene
@export var collision: PackedScene
@export var has_sprite_no_model: bool = false
@export var sprite: PackedScene
@export var delete_on_use: bool = false
@export var custom_sound_file: AudioStream
@export var drop_scene_path: String = ""

var _hold_timer: float = 0.0
var _is_holding: bool = false
var _completed: bool = false

var can_use: bool
var is_selected: bool

func _process(_delta: float) -> void:
	if is_selected:
		if can_use:
			GlobalPlayer.interaction.show_interactable_visual()
		else: GlobalPlayer.interaction.hide_interaction_visual()

# use() gaat worden gecalled wanneer de player mouse button ingedrukt houdt. 
# dit is eig om recursion te voorkomen
func use(delta: float):
	if can_use:
		if min_use_time == 0.0:
			do_item_thing()
			if delete_on_use: 
				GlobalPlayer.inventory.delete_item_from_current_slot()
				queue_free()
		else:
			_is_holding = true
			_hold_timer += delta
			if _hold_timer >= min_use_time and not _completed:
				_completed = true
				do_item_thing()
				if delete_on_use: 
					GlobalPlayer.inventory.delete_item_from_current_slot()
					queue_free()

# wanneer je extend, schrijf hier de logic voor wat de item doet.
func do_item_thing():
	pass

func cancel_use():
	if not _completed:
		_hold_timer = 0.0
	_is_holding = false
	_completed = false
	_hold_timer = 0.0

func on_select():
	is_selected = true

func on_deselect():
	is_selected = false

func drop():
	if drop_scene_path == "":
		return
	var packed := load(drop_scene_path) as PackedScene
	if packed == null:
		return
	var spawn := packed.instantiate()
	var player: CharacterBody3D = GlobalPlayer.player
	var forward := -player.transform.basis.z.normalized()
	var drop_pos: Vector3 = player.global_position + forward * 1.2
	var space := player.get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(drop_pos, drop_pos + Vector3.DOWN * 10.0)
	query.exclude = [player.get_rid()]
	var hit := space.intersect_ray(query)
	if hit:
		drop_pos = hit.position + Vector3.UP * 0.2
	GlobalPlayer.player.get_parent().add_child(spawn)
	spawn.global_position = drop_pos
