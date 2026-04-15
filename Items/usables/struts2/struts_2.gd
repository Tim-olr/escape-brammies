extends UsableItem

func do_item_thing():
	GlobalRefs.brammy.wanderingSpeed -= GlobalRefs.brammy.wanderingSpeed * 0.1
	GlobalRefs.brammy.chaseSpeed -= GlobalRefs.brammy.chaseSpeed * 0.1
	GlobalPlayer.audio.set_stream_and_audio(custom_sound_file, -40.0)
	GlobalPlayer.audio.play()
	queue_free()
