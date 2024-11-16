extends Control

signal fade_in_complete

@export var next_scene: String = "res://scenes/battle.tscn"



# Called when the node enters the scene tree for the first time.
func _ready():
	# Play the fade-in sequence animation
	$AnimationPlayer.play("FadeIn")
	print("Fade in called. Starting...")

func on_fade_in_complete():
	emit_signal("fade_in_complete")
	print("Fade-in completed. Changing scene.")
	get_tree().change_scene_to_file("res://scenes/battle.tscn")
