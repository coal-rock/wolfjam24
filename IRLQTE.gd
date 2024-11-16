extends QTE

var irlgames = ["Thumb War!!", "Rock Paper Scissors!!"]

var allowinp = false

func _ready() -> void:
	var game = irlgames[randi() % len(irlgames)]
	$Label.text = game
	await get_tree().create_timer(1).timeout
	$Label.text = game + "\n in 3.."
	await get_tree().create_timer(1).timeout
	$Label.text = game + "\n in 3.. 2.."
	await get_tree().create_timer(1).timeout
	$Label.text = game + "\n in 3.. 2.. 1.."
	await get_tree().create_timer(1).timeout
	allowinp = true
	$Label.text = game + "\n\n who won? (press key)"

func _process(delta: float) -> void:
	if allowinp:
		if Input.is_action_just_pressed(battle.inputName1):
			battle.qte_finished(battle.dice1)
		if Input.is_action_just_pressed(battle.inputName2):
			battle.qte_finished(battle.dice2)
