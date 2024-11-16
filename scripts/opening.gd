extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	# Play the fade-in sequence animation
	$AnimationPlayer.play("FadeIn")
