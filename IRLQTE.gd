extends QTE

var irlgames = ["Thumb War", "Rock Paper Scissors", "Odds and Evens", "Nose Goes", "Name A"]
var irldescriptions = []
var nouns = ["Fruit", "Bird", "State", "Country", "Dog Breed", "Cheese", "Goblin", "Color", "Restaraunt", "Vegetable", "Category"]
var allowinp = false

func _ready() -> void:
	var game = irlgames[randi() % len(irlgames)]
	var notimer = false
	
	if game == "Name A":
		notimer = true
		game = "Name A " + nouns[randi() % len(nouns)]
	$Label.text = game
	
	if game == "Nose Goes":
		notimer = true
		
	if !notimer:
		await get_tree().create_timer(1).timeout
		$Label.text = game + "\n in 3.."
		await get_tree().create_timer(1).timeout
		$Label.text = game + "\n in 3.. 2.."
		await get_tree().create_timer(1).timeout
		$Label.text = game + "\n in 3.. 2.. 1.."
	await get_tree().create_timer(1).timeout
	allowinp = true
	battle.play_fanfare()
	$Label.text = game + "\n\n who won? (press key)"

func _process(delta: float) -> void:
	if allowinp:
		if Input.is_action_just_pressed(battle.inputName1):
			battle.qte_finished(battle.dice1)
		if Input.is_action_just_pressed(battle.inputName2):
			battle.qte_finished(battle.dice2)
