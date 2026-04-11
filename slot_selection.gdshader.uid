extends Interactable

const TEST_USABLE = preload("uid://dj0ij144jaak8")
var usable

func interact():
	usable = TEST_USABLE.instantiate()
	GlobalPlayer.inventory.add_item(usable)
	check_go_away()
