extends Node

class_name DiceRoller
@export var is_rolled = false;
@export var spr: Sprite2D;
@export var sides: int = 6;

func _ready() -> void:
	spr = $Sprite2D
	
func roll() -> int:
	return randi() % sides + 1

func update_die() -> void:
	var roll: int = roll()
	spr.frame = roll - 1
	is_rolled = true
