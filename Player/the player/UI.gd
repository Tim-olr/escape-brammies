extends CanvasLayer

@onready var label: RichTextLabel = $RichTextLabel
var timer: SceneTreeTimer

func _ready() -> void:
	GlobalPlayer.promptinstance = self;

func show_prompt(text: String, duration: float = 2.0) -> void:
	label.text = "[center]"+text+"[/center]"
	label.visible = true
	
	# Reset vorige timer als die nog loopt
	if timer:
		timer.time_left = duration
		return
		
	timer = get_tree().create_timer(duration)
	timer.timeout.connect(hide_prompt)
	return

func hide_prompt() -> void:
	label.visible = false
	timer = null
