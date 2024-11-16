extends Node

class_name DiceRoller
@export var is_rolled = false;
@export var spr: Sprite2D;
@onready var anim_spr = $AnimatedSprite2D
@export var sides: int = 6;
@export var score: int = 0;
@export var last_roll: int = 0;
var dice_roll_sound = preload("res://assets/sounds/dice_roll.wav")

var bad_num_sound
var event_num_sound
var best_num_sound

var anim_count = 0

func _ready() -> void:
	spr = $Sprite2D
	
	if self.name == "Player 1":
		bad_num_sound = preload("res://assets/sounds/goblin_bad_num.wav")
		event_num_sound = preload("res://assets/sounds/goblin_event_num.wav")
		best_num_sound = preload("res://assets/sounds/goblin_best_num.wav")
	elif self.name == "Player 2":
		bad_num_sound = preload("res://assets/sounds/hob_bad_num.wav")
		event_num_sound = preload("res://assets/sounds/hob_event_num.wav")
		best_num_sound = preload("res://assets/sounds/hob_best_num.wav")
	
func roll() -> int:
	return randi() % sides + 1

func update_die() -> void:
	spr.visible = false
	anim_spr.visible = true
	
	anim_spr.play("d6_roll")
	$AudioStreamPlayer2D.stream = dice_roll_sound
	$AudioStreamPlayer2D.play()
	

func animation_looped() -> void:
	anim_count += 1
	
#	play animation exactly twice!!s
	if anim_count == 2:
		anim_spr.stop()
		
		var roll: int = roll()
		spr.frame = roll - 1
		is_rolled = true
		
		if roll == 6:
			$AudioStreamPlayer2D.stream = best_num_sound
			$AudioStreamPlayer2D.play()
		else:
			$AudioStreamPlayer2D.stream = bad_num_sound
			$AudioStreamPlayer2D.play()
			
			
		
		spr.visible = true
		anim_spr.visible = false
		anim_count = 0
		last_roll = roll
		get_parent().roll_finished(self, roll)
