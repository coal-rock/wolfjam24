extends QTE

var allowinp = false
var c1 = 0
var c2 = 0

var timeleft = 300

func _ready() -> void:
	var tx = "mash your button as fast as you can"
	$Label.text = tx+"\n"
	await get_tree().create_timer(1).timeout
	$Label.text = tx + "\n in 3.."
	await get_tree().create_timer(1).timeout
	$Label.text = tx + "\n in 3.. 2.."
	await get_tree().create_timer(1).timeout
	$Label.text = tx + "\n in 3.. 2.. 1"
	await get_tree().create_timer(1).timeout
	$Label.text = "mash your button as fast as you can !!!"
	allowinp = true

func _process(delta: float) -> void:
	if allowinp:
		if Input.is_action_just_pressed(battle.inputName1):
			c1+=1
		if Input.is_action_just_pressed(battle.inputName2):
			c2+=1
		$Label.text = "%s left" % timeleft
		$counter1.text = "%s" % c1
		$counter2.text = "%s" % c2
		
		timeleft-=1
		if timeleft <= 0:
			if c1 > c2:
				battle.qte_finished(battle.dice1)
			else:
				battle.qte_finished(battle.dice2)
