extends Node

class_name DiceRoller
@export var is_rolled = false;
@export var spr: Sprite2D;
@onready var anim_spr = $AnimatedSprite2D
@export var sides: int = 6;

func _ready() -> void:
	spr = $Sprite2D
	
func roll() -> int:
	return randi() % sides + 1

func update_die() -> void:
	spr.visible = false
	anim_spr.visible = true
	
	anim_spr.play("d6_roll")

func animation_looped() -> void:
	anim_spr.stop()
	
	var roll: int = roll()
	spr.frame = roll - 1
	is_rolled = true
	
	spr.visible = true
	anim_spr.visible = false
