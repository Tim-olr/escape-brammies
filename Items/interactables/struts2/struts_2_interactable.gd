extends Interactable

const STRUTS_2 = preload("uid://b78rvo83hladx")

var usable

func interact() -> bool:
	usable = STRUTS_2.instantiate()
	if GlobalPlayer.inventory.add_item(usable):
		check_go_away()
		return true
	else: return false
