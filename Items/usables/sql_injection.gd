extends UsableItem

func do_item_thing():
	GlobalPlayer.manager.pause_everything_except_player()
