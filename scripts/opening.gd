extends Control

signal text_fade_in_complete

@export var next_scene: String = "res://scenes/instructions.tscn"

func _ready():
	# Connect the signal once in _ready()
	if not $AnimationPlayer.is_connected("animation_finished", Callable(self, "_on_fade_out_complete")):
		$AnimationPlayer.connect("animation_finished", Callable(self, "_on_fade_out_complete"))
		$AnimationPlayer.play("FadeIn")
		print("Fade-in called. Starting...")

func on_fade_in_complete():
	emit_signal("text_fade_in_complete")
	print("Text fade-in completed. Preparing scene transition...")
	transition_to_next_scene()

# Start fade-out and wait for it to complete before transitioning scenes
func transition_to_next_scene():
	print("Starting fade-out...")
	$AnimationPlayer.play("FadeOut")

func _on_fade_out_complete(anim_name: String):
	if anim_name == "FadeOut":
		print("Fade-out completed. Changing scene...")
		get_tree().change_scene_to_file("res://scenes/instructions.tscn")
