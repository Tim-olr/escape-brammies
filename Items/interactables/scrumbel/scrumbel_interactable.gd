extends Interactable

const SCRUMBEL = preload("uid://sk8gw3cysmfg")

var usable

func interact() -> bool:
	usable = SCRUMBEL.instantiate()
	if GlobalPlayer.inventory.add_item(usable):
		check_go_away()
		return true
	else: return false
