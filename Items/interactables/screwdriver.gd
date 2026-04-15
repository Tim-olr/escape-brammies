extends UsableItem

func do_item_thing():
	GlobalPlayer.audio.set_stream_and_audio(custom_sound_file, -30.0)
	GlobalPlayer.audio.play()
	GlobalRefs.brammy.attention_area.scale *= 0.9
