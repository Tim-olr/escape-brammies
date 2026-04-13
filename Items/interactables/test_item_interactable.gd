extends Interactable
class_name TestInteractable

const SQL_INJECTION = preload("uid://dwwe753atfxn0")

var usable

func interact() -> bool:
	usable = SQL_INJECTION.instantiate()
	if GlobalPlayer.inventory.add_item(usable):
		check_go_away()
		return true
	else: return false
