extends Node2D

@export var dice1: DiceRoller
@export var dice2: DiceRoller

@export var inputName1: String
@export var inputName2: String


func roll(sides: int) -> int:
	if sides <= 0:
		return 0  # Invalid dice
	return randi() % sides + 1

func update_die(r: DiceRoller, sides: int) -> void:
	var roll: int = roll(6)
	r.spr.frame = roll - 1
	r.is_rolled = true
	
	# now if both have a roll, start the battle
	if dice1.is_rolled && dice2.is_rolled:
		print("BOTH ROLL")
		dice1.is_rolled = false
		dice2.is_rolled = false
		if dice1.spr.frame == dice2.spr.frame:
			print("BOTH MATCH")

func _on_ready() -> void:	
	update_die(dice1, 6)
	update_die(dice2, 6)

func _process(delta):
	if Input.is_action_just_pressed(inputName1):
		update_die(dice1, 6)
	if Input.is_action_just_pressed(inputName2):
		update_die(dice2, 6)
