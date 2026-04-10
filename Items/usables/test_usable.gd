extends UsableItem

func do_item_thing():
	print("doing the thing")

func on_select():
	super()
	can_use = true

func on_deselect():
	super()
	can_use = false
