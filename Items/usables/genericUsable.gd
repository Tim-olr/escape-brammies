extends Node
class_name UsableItem

@export_category("info")
@export var item_name: String
@export var min_use_time: float = 0.0 # laat deze op 0.0 als het een insta use is
@export var custom_texture: Texture2D # Kan niet null zijn pls
@export var model: PackedScene
@export var collision: PackedScene

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
		else:
			_is_holding = true
			_hold_timer += delta
			if _hold_timer >= min_use_time and not _completed:
				_completed = true
				do_item_thing()

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
	if model != null and collision != null:
		var actual_model = model.instantiate()
		var drop_pos = GlobalPlayer.manager.calculate_drop_height()
		var interactable = TestInteractable.new()
		var col = collision.instantiate()
		interactable.add_child(col)
		interactable.add_child(actual_model)
		GlobalPlayer.player.get_parent().add_child(interactable)
		interactable.global_position = drop_pos
		
