extends Node2D

var elapsed_time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.global_position = Vector2(randi_range(100, 1820), 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	elapsed_time += delta * (randf() * 5)
	self.global_position += Vector2(0.0, 300 * delta * (elapsed_time * 2))
	
	if self.global_position.y > 1200:
		self.queue_free()
