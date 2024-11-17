extends Control

func _on_play_button_pressed():
	print("Starting fade-out...")
	$AnimationPlayer.play("FadeOut")
	get_tree().change_scene_to_file("res://scenes/opening.tscn")

func _on_credits_button_pressed():
	print("Credits button pressed")
	get_tree().change_scene_to_file("res://scenes/credits.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
