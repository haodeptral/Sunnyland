@tool
extends TextureButton

signal level_selected

@export var locked: bool = true:
	set(value):
		locked = value
		level_unlocked() if not locked else level_locked()
@export var level_num = 1

func level_state(value: bool) -> void:
	disabled = value
	$Label.visible = not value
	#print($Label.visible)
	
func level_unlocked() -> void:
	level_state(false)
	$Label.text = str(level_num)
	#print("Unlocked")
	
func level_locked() -> void:
	level_state(true)
	#print("Locked")


func _on_pressed() -> void:
	level_selected.emit(level_num)
	#print("Pressed")
	#level_locked()
	#level_unlocked()
	#level_state(false)
