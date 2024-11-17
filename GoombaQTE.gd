extends QTE

var allowinp = false
var c1 = 0
var c2 = 0

var timeleft = 500

var numcoins = 0

func addloop():
	while allowinp:
		var goomb = preload("res://scenes/goomba.tscn").instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
		goomb.position.x = randf()*get_viewport().size.x/2+get_viewport().size.x/4
		goomb.position.y = get_viewport().size.y+100
		get_tree().get_root().add_child(goomb)
		await get_tree().create_timer(randf_range(0.2,1.5)).timeout
		numcoins += 1

func _ready() -> void:
	allowinp = true
	addloop()
	

func _process(delta: float) -> void:
	$Label.text = "Count the steaks!"
	
	if allowinp:
		if Input.is_action_just_pressed(battle.inputName1):
			c1+=1
		if Input.is_action_just_pressed(battle.inputName2):
			c2+=1
		$counter1.text = "%s" % c1
		$counter2.text = "%s" % c2
		
		timeleft-=1
		if timeleft <= 0:
			allowinp = false
			await get_tree().create_timer(3).timeout
			var delta1 = abs(c1 - numcoins)
			var delta2 = abs(c2 - numcoins)
			if min(delta1, delta2) == delta1:
				battle.qte_finished(battle.dice1)
			else:
				battle.qte_finished(battle.dice2)
