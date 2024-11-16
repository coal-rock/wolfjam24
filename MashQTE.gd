extends QTE

var allowinp = false
var c1 = 0
var c2 = 0

var timeleft = 300

func _ready() -> void:
	$Label.text = "mash buttons.. get ready"
	await get_tree().create_timer(1).timeout
	allowinp = true

func _process(delta: float) -> void:
	if allowinp:
		if Input.is_action_just_pressed(battle.inputName1):
			c1+=1
		if Input.is_action_just_pressed(battle.inputName2):
			c2+=1
		$Label.text = "%s left" % timeleft
		$counter1.text = "%s clicks" % c1
		$counter2.text = "%s clicks" % c2
		
		timeleft-=1
		if timeleft <= 0:
			if c1 > c2:
				battle.qte_finished(battle.dice1)
			else:
				battle.qte_finished(battle.dice2)
