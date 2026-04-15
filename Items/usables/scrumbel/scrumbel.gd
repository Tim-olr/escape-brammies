extends UsableItem

func do_item_thing():
	GlobalPlayer.audio.set_stream_and_audio(custom_sound_file, -20.0)
	GlobalPlayer.audio.play()
	GlobalRefs.main.ding()
	GlobalRefs.main.dinged = true
