extends UsableItem

func do_item_thing():
	GlobalPlayer.audio.set_stream_and_audio(custom_sound_file, -40.0)
	GlobalPlayer.audio.play()
	GlobalPlayer.manager.pause_everything_except_player()
