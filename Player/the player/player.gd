extends CharacterBody3D
class_name Player
@onready var player_interaction: RayCast3D = $Camera3D/PlayerInteraction

@onready var manager: PlayerManager = $PlayerManager


func _ready() -> void:
	GlobalPlayer.player = self
	GlobalPlayer.interaction = player_interaction
