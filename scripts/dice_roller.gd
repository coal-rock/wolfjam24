extends Node2D

class_name DiceRoller
@export var is_rolled = false;
@export var spr: Sprite2D;
@onready var anim_spr = $AnimatedSprite2D

@export var sides: int = 6;
@export var score: int = 1;
@export var last_roll: int = 0;
@export var coins: int = 0;
@export var bonus: int = 0;

var dice_roll_sound = preload("res://assets/sounds/dice_roll.wav")
var gold_spr = preload("res://assets/dice/gold_d6.png")
var normal_spr = preload("res://assets/dice/d6.png")

var anim_name = "d6_roll"

var bad_num_sound
var event_num_sound
var best_num_sound

var anim_count = 0

var event_counter = 0
var prefer_roll = -1

var sx
var sy

func _ready() -> void:
	spr = $Sprite2D;
	
	sx = position.x
	sy = position.y
	
	if self.name == "Player 1":
		bad_num_sound = preload("res://assets/sounds/goblin_bad_num.wav")
		event_num_sound = preload("res://assets/sounds/goblin_event_num.wav")
		best_num_sound = preload("res://assets/sounds/goblin_best_num.wav")
	elif self.name == "Player 2":
		bad_num_sound = preload("res://assets/sounds/hob_bad_num.wav")
		event_num_sound = preload("res://assets/sounds/hob_event_num.wav")
		best_num_sound = preload("res://assets/sounds/hob_best_num.wav")


func roll() -> int:
#	weight dice after two boring roll
	var roll
	
	anim_name = "d6_roll"
	spr.texture = normal_spr

	if event_counter >= 2:
		roll = (randi() % (sides / 2) + 1) * 2 
	else:
		roll = randi() % sides + 1
	
	if randi() % 12 == 1:
		# force collision
		roll = prefer_roll
		print("triggered force battle")
		
	roll = min(6, roll + bonus)
	bonus = 0
	
	return roll
		

func update_die() -> void:
	spr.visible = false
	anim_spr.visible = true
	modulate = Color.DARK_GRAY
	
	anim_spr.play(anim_name)
	$AudioStreamPlayer2D.stream = dice_roll_sound
	$AudioStreamPlayer2D.play()
	shake_loop()
	
var rolldone = false
func shake_loop():
	rolldone = false
	while !rolldone:
		position.x = sx + randf()*10
		position.y = sy + randf()*10
		await get_tree().create_timer(0.1).timeout
	position.x = sx
	position.y = sy

func add_bonus() -> void:
	coins -= 1
	bonus += 1
	
	spr.texture = gold_spr
	anim_name = "d6_roll_gold"
	

func animation_looped() -> void:
	anim_count += 1
	
#	play animation exactly twice!!s
	if anim_count == 2:
		anim_spr.stop()
		
		var roll: int = roll()
		spr.frame = roll - 1
		is_rolled = true
		event_counter += 1
		
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
		
		rolldone = true
		get_parent().roll_finished(self, roll)
