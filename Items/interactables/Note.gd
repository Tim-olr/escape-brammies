extends Node3D
class_name Note

## The note text. Use {code} as a placeholder for the linked keypad's code.
## When digit_index is set, {code} is replaced with just that one digit.
## Example: "The first digit is {code}."
@export_multiline var text: String = "{code}"

## Optional keypad — its code (or one digit of it) replaces {code} in the text.
@export var keypad: Keypad = null

## Which digit of the code to show (0 = first, 1 = second, etc.).
## Set to -1 to show the full code instead.
@export var digit_index: int = -1

const ORDINALS := ["First", "Second", "Third", "Fourth", "Fifth", "Sixth"]

@onready var label: Label3D = $Label3D

var _revealed: bool = false

func _ready() -> void:
	label.text = ""
	call_deferred("_update_label")

func _process(_delta: float) -> void:
	if _revealed:
		return
	if GlobalRefs.brammy != null and GlobalRefs.brammy.started:
		_revealed = true
		_update_label()

func _update_label() -> void:
	if not _revealed:
		label.text = ""
		return

@onready var label: Label3D = $Label3D

func _ready() -> void:
	call_deferred("_update_label")

const ORDINALS := ["First", "Second", "Third", "Fourth", "Fifth", "Sixth"]

func _update_label() -> void:
const ORDINALS := ["First", "Second", "Third", "Fourth", "Fifth", "Sixth"]

@onready var label: Label3D = $Label3D

var _revealed: bool = false

func _ready() -> void:
	label.text = ""
	call_deferred("_update_label")

func _process(_delta: float) -> void:
	if _revealed:
		return
	if GlobalRefs.brammy != null and GlobalRefs.brammy.started:
		_revealed = true
		_update_label()

func _update_label() -> void:
	if not _revealed:
		label.text = ""
		return

	if keypad == null:
		label.text = text
		return

	if digit_index >= 0 and digit_index < keypad.code.length():
		var ordinal: String = ORDINALS[digit_index] if digit_index < ORDINALS.size() else "Digit %d" % (digit_index + 1)
		label.text = "%s digit:\n%s" % [ordinal, keypad.code[digit_index]]
	else:
		label.text = text.replace("{code}", keypad.code)
