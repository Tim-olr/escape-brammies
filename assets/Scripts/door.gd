extends Interactable

@export var openOtherWay: bool = false;
@export var locked: bool = false;

var opened: bool = false
var tweeling: Tween

func _ready() -> void:
	opened = false

func interact() -> bool:
	if(!locked):
		opened = !opened
		
		if tweeling:
			tweeling.kill()
		
		tweeling = create_tween()
		var target = (90.0 if !openOtherWay else -90.0) if opened else 0.0
		
		tweeling.tween_property(
			get_parent(),
			"rotation_degrees:y",
			target,
			0.5
		).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
		
	else: 
		GlobalPlayer.promptinstance.show_prompt("This door is locked")
	
	return true
