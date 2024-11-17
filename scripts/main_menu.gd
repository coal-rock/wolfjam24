extends Control

signal play_pressed
signal exit_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_play_button_pressed() -> void:
	emit_signal("play_pressed")
	transition_to_next_scene()
	
	# Start fade-out and wait for it to complete before transitioning scenes
func transition_to_next_scene():
	print("Starting fade-out...")
	$AnimationPlayer.play("FadeOut")
	get_tree().change_scene_to_file("res://scenes/opening.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
