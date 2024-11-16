extends QTE
class_name RhythmQTE


var inputs = ["up","down", "left", "right"]

var selectedinput = -1
var timeleft = -1

var score = 0

@onready
var mylabel = $Label

func _ready() -> void:
	reinit()
var allowinp = false
	
func reinit() -> void:
	var tx = "Press the direction in 3.."
	mylabel.text = tx
	await get_tree().create_timer(1).timeout
	mylabel.text = tx + "2.."
	await get_tree().create_timer(1).timeout
	mylabel.text = tx + "2.. 1.."
	await get_tree().create_timer(1).timeout
	mylabel.text = "press!"
	timeleft = 300
	selectedinput = inputs[randi() % len(inputs)]
	allowinp = true
	# show direction now
	var spriets = {
		"up": preload("res://assets/Up.png"),
		"down": preload("res://assets/Down.png"),
		"left": preload("res://assets/Left.png"),
		"right": preload("res://assets/Right.png"),
	}
	$Sprite2D.visible = true
	$Sprite2D.texture = spriets[selectedinput]

var byp = 0
func _process(delta: float) -> void:
	if !allowinp:
		return
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
	if Input.is_action_just_pressed(inputs1[selectedinput]):
		byp = 1
		byp = 0
		battle.qte_finished(battle.dice1)
	if Input.is_action_just_pressed(inputs2[selectedinput]):
		byp = 1
		#await get_tree().create_timer(1).timeout
		byp = 0
		battle.qte_finished(battle.dice2)		
	
