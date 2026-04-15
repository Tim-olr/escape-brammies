extends Interactable

const WHITE_BREW = preload("uid://bsnn6txjxvln2")

var usable

func interact() -> bool:
	usable = WHITE_BREW.instantiate()
	if GlobalPlayer.inventory.add_item(usable):
		check_go_away()
		return true
	else: return false
