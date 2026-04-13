extends UsableItem

func do_item_thing():
	if GlobalPlayer.manager.can_sql:
		GlobalPlayer.audio.set_stream_and_audio(custom_sound_file, -40.0)
		GlobalPlayer.audio.play()
		GlobalPlayer.manager.can_sql = false
		GlobalPlayer.manager.pause_everything_except_player()
		GlobalPlayer.inventory.delete_item_from_current_slot()
		queue_free()
