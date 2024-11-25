extends ColorRect

var fade_tween: Tween

func _ready():
	self.modulate = Color(0, 0, 0, 0)  # Black with full transparency
	self.visible = false
	self.z_index = 100  # Ensure it's on top of other UI elements

func fade_screen(fade_to_black: bool, duration: float, callback: Callable) -> void:
	print("Starting fade_screen...")

	self.visible = true
	var fader_color = 1.0 if fade_to_black else 0.0

	if is_instance_valid(fade_tween) and fade_tween.is_running():
		fade_tween.stop()
		print("Stopped existing tween")

	fade_tween = get_tree().create_tween()
	if not is_instance_valid(fade_tween):
		print("Failed to create tween")
		return

	fade_tween.tween_property(self, "modulate:a", fader_color, duration)
	print("Tween started with target alpha:", fader_color)

	if not callback.is_null():
		print("Callback is valid, adding to tween")
		fade_tween.tween_callback(callback)
	else:
		print("No callback provided")

	fade_tween.tween_callback(Callable(self, "_hide_if_transparent"))

func _hide_if_transparent():
	if self.modulate.a == 0.0:
		self.visible = false
		print("Fader hidden due to full transparency")
