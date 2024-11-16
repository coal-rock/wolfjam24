extends Node2D
class_name Battle

@export var score1: Node2D
@export var score2: Node2D

@export var dice1: DiceRoller
@export var dice2: DiceRoller

@export var inputName1: String
@export var inputName2: String

@export var up1: String
@export var left1: String
@export var down1: String
@export var right1: String

@export var up2: String
@export var left2: String
@export var down2: String
@export var right2: String

@onready var vignete = $Vignete 
@onready var timer = $Timer

@onready var win_vignette = $WinVignette
@onready var win_text = $WinText

enum GameState { DICE, QTE, MENU, WIN }

@export var state = GameState.DICE
@export var win_condition: int = 6
@export var winner: String = ""

var battle_start = preload("res://assets/sounds/battle_start.wav")
var qte_start = preload("res://assets/sounds/qte_start.wav")

var qte_scenes = [preload("res://node_2d_qte.tscn")]
var active_qte: QTE
func change_state(s: GameState):
	state = s
	if state == GameState.QTE:
		vignete.visible = true
	else:
		vignete.visible = false

func handle_roll(r: DiceRoller) -> void:
	r.update_die()
	
# who rolled a 6
var roller: DiceRoller

# true if the qte is a battle event (when 6 is rolled)
var qte_is_battle = false
	
func roll_finished(r: DiceRoller, roll:int):
	
	
	if dice1.is_rolled && dice2.is_rolled:
		print("BOTH ROLL")
		dice1.is_rolled = false
		dice2.is_rolled = false
		timer.wait_time = 1.0
		timer.one_shot = true 
		timer.start()
		
		if dice1.last_roll == 6 && dice2.last_roll == 6:
			print("implement")
			return
		
		# if both are the same do qte
		if dice1.spr.frame == dice2.spr.frame && dice1.score > 0 && dice2.score > 0:
			qte_is_battle = false
			await get_tree().create_timer(0.5).timeout
			$AudioStreamPlayer2D.stream = qte_start
			$AudioStreamPlayer2D.play()
			await get_tree().create_timer(1.0).timeout
			start_qte(qte_scenes[randi() % len(qte_scenes)])
		
		if roll == 6:
			roller = r
			qte_is_battle = true
			await get_tree().create_timer(0.5).timeout
			$AudioStreamPlayer2D.stream = battle_start
			$AudioStreamPlayer2D.play()
			await get_tree().create_timer(1.0).timeout
			start_qte(preload("res://irl_qte.tscn"))

func start_qte(scene):
	change_state(GameState.QTE)
	$BattleText.visible = true
	await get_tree().create_timer(2).timeout
	$BattleText.visible = false
	active_qte = scene.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	active_qte.battle = self
	get_tree().get_root().add_child(active_qte)
	
# called by the qte script
func qte_finished(whoWon: DiceRoller):
	active_qte.queue_free()
	change_state(GameState.DICE)
	print("dice %s won" % whoWon)
	if qte_is_battle:
		print("what")
		print(whoWon, roller)
		if whoWon == roller:
			roller.score += 1
	else:
		if whoWon == dice1:
			dice2.score -=1
		else:
			dice1.score -=1

func _on_ready() -> void:
	handle_roll(dice1)
	handle_roll(dice2)

func reset_score(ui: Node2D) -> void:
	for i in win_condition:
		ui.get_node("d" + str(i + 1)).visible = false

func update_score(ui: Node2D, score: int) -> void:
	reset_score(ui)
	
	for i in score:
		ui.get_node("d" + str(i + 1)).visible = true

func _process(delta):
	if state == GameState.DICE && timer.is_stopped():
		if dice1.score == win_condition:
			winner = "Goblin"
			change_state(GameState.WIN)
		elif dice2.score == win_condition:
			winner = "Hobgoblin"
			change_state(GameState.WIN)
				
		if Input.is_action_just_pressed(inputName1) && !dice1.is_rolled:
			handle_roll(dice1)
		if Input.is_action_just_pressed(inputName2) && !dice2.is_rolled:
			handle_roll(dice2)
			
		update_score(score1, dice1.score)
		update_score(score2, dice2.score)
	
	if state == GameState.WIN:
		win_vignette.visible = true
		win_text.text = winner + " wins!"
		win_text.visible = true
