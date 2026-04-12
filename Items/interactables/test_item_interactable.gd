extends Interactable
class_name TestInteractable

const TEST_USABLE = preload("uid://dj0ij144jaak8")
var usable

func interact() -> bool:
	usable = TEST_USABLE.instantiate()
	if GlobalPlayer.inventory.add_item(usable):
		check_go_away()
		return true
	else: return false
