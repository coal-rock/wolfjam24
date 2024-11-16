extends QTE

var irlgames = ["Thumb War!!", "Rock Paper Scissors!!"]

var allowinp = false

func _ready() -> void:
	$Label.text = irlgames[randi() % len(irlgames)]
	await get_tree().create_timer(3).timeout
	allowinp = true
	$Label.text = "who won? (press key)"

func _process(delta: float) -> void:
	if allowinp:
		if Input.is_action_just_pressed(battle.inputName1):
			battle.qte_finished(battle.dice1)
		if Input.is_action_just_pressed(battle.inputName2):
			battle.qte_finished(battle.dice2)
