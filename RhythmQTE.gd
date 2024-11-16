extends QTE
class_name RhythmQTE

var inputs = [KEY_W, KEY_A, KEY_S, KEY_D]
var selectedinput = -1
var timeleft = -1

var score = 0

@onready
var mylabel = get_node("Node2D/Label")

func _ready() -> void:
	reinit()
	
func reinit() -> void:
	timeleft = 300
	selectedinput = inputs[randi() % len(inputs)]

var byp = 0

func _process(delta: float) -> void:
	if byp == 1:
		return
	timeleft -= 1
	mylabel.text = "PRESS %s (%s)" % [ OS.get_keycode_string(selectedinput),timeleft]
	if Input.is_key_pressed(selectedinput):
		mylabel.text = "pressed!"
		score += 1
		if score > 2:
			battle.qte_finished(battle.dice1)
		byp = 1
		await get_tree().create_timer(1).timeout
		byp = 0
		reinit()
	if timeleft <= 0:
		mylabel.text = "time ran out"
		
	
