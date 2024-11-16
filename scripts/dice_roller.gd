extends Node

class_name DiceRoller
@export var is_rolled = false;
@export var spr: Sprite2D;
@onready var anim_spr = $AnimatedSprite2D
@export var sides: int = 6;
@export var score: int = 0;

var anim_count = 0

func _ready() -> void:
	spr = $Sprite2D
	
func roll() -> int:
	return randi() % sides + 1

func update_die() -> void:
	spr.visible = false
	anim_spr.visible = true
	
	anim_spr.play("d6_roll")

func animation_looped() -> void:
	anim_count += 1
	
#	play animation exactly twice!!s
	if anim_count == 2:
		anim_spr.stop()
		
		var roll: int = roll()
		spr.frame = roll - 1
		is_rolled = true
		if roll == 6:
			score += 1
		
		spr.visible = true
		anim_spr.visible = false
		anim_count = 0
		get_parent().roll_finished(self)
