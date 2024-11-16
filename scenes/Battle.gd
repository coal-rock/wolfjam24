extends Node2D

@export var dice1: DiceRoller
@export var dice2: DiceRoller

@export var inputName1: String
@export var inputName2: String

func handle_roll(r: DiceRoller) -> void:
	r.update_die()
	
	if dice1.is_rolled && dice2.is_rolled:
		print("BOTH ROLL")
		dice1.is_rolled = false
		dice2.is_rolled = false
		
		# now if both have a roll, start the battle	
		if dice1.spr.frame == dice2.spr.frame:
			print("BOTH MATCH")

func _on_ready() -> void:	
	handle_roll(dice1)
	handle_roll(dice2)

func _process(delta):
	if Input.is_action_just_pressed(inputName1):
		handle_roll(dice1)
	if Input.is_action_just_pressed(inputName2):
		handle_roll(dice2)
