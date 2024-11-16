extends Node

class_name DiceRoller
@export var is_rolled = false;
@export var spr: Sprite2D;

func _ready() -> void:
	spr = $Sprite2D
	print(spr)
	
	
