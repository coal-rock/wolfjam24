extends Control

@export var next_scene: String = "res://scenes/battle.tscn"  # Path to the next scene
@export var transition_delay: float = 5.0  # Time in seconds before automatic transition

var timer_started = false  # Ensures we only transition once

func _ready():
	# Start the timer for the automatic transition
	var timer = Timer.new()
	timer.wait_time = transition_delay
	timer.one_shot = true
	add_child(timer)
	timer.start()
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	if not timer_started:
		transition_to_next_scene()

func _input(event):
	# Detect any keyboard or controller input
	if event.is_pressed():
		transition_to_next_scene()

func transition_to_next_scene():
	if not timer_started:
		timer_started = true
		print("Transitioning to next scene...")
		get_tree().change_scene_to_file(next_scene)
