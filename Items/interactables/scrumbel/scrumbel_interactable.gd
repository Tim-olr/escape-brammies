extends Interactable

const SCRUMBEL = preload("uid://sk8gw3cysmfg")

var usable

func _ready() -> void:
	scale = Vector3(0.3, 0.3, 0.3)

func _process(_delta: float) -> void:
	if GlobalRefs.brammy.started:
		add_to_group("interactable")

func interact() -> bool:
	usable = SCRUMBEL.instantiate()
	if GlobalPlayer.inventory.add_item(usable):
		check_go_away()
		return true
	else: return false
