extends AudioStreamPlayer3D
class_name PlayerAudio

func _ready() -> void:
	GlobalPlayer.audio = self

func set_stream_and_audio(file, volume):
	stream = file
	volume_db = volume
