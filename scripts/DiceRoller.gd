extends Node

@onready var dice_sprite := $Sprite2D as Sprite2D
@export var inputName: String

# Roll a dice with the given number of sides.
func roll(sides: int) -> int:
	if sides <= 0:
		return 0  # Invalid dice
	return randi() % sides + 1

func update_die(sides: int) -> void:
	var roll: int = roll(6)
	dice_sprite.frame = roll - 1
	print(roll)

func _on_ready() -> void:	
	update_die(6)

func _process(delta):
	print(inputName)
	if Input.is_action_just_pressed(inputName):
		update_die(6)
