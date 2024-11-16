extends QTE
class_name RhythmQTE


var inputs = ["up","down", "left", "right"]

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
	var inputs1 = {
		"up": battle.up1,
		"down": battle.down1,
		"left": battle.left1,
		"right": battle.right1,
	}

	var inputs2 = {
		"up": battle.up2,
		"down": battle.down2,
		"left": battle.left2,
		"right": battle.right2,
	}
	if byp == 1:
		return
	mylabel.text = "PRESS %s" % selectedinput
	if Input.is_action_just_pressed(inputs1[selectedinput]):
		byp = 1
		#await get_tree().create_timer(1).timeout
		byp = 0
		battle.qte_finished(battle.dice1)
	if Input.is_action_just_pressed(inputs2[selectedinput]):
		byp = 1
		#await get_tree().create_timer(1).timeout
		byp = 0
		battle.qte_finished(battle.dice2)		
	
