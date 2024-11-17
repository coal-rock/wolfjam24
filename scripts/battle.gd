extends Node2D
class_name Battle

@export var score1: Node2D
@export var score2: Node2D

@export var coin1: Node2D
@export var coin2: Node2D

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

@onready var bonus1 = $Player1Bonus
@onready var bonus2 = $Player2Bonus

enum GameState { DICE, QTE, MENU, WIN }

@export var state = GameState.DICE
@export var win_condition: int = 6
@export var winner: String = ""

var qte_scenes = [preload("res://node_2d_qte.tscn"), preload("res://mash_qte.tscn"), preload("res://goomba_qte.tscn")]
var battle_start = preload("res://assets/sounds/battle_start.wav")
var qte_start = preload("res://assets/sounds/qte_start.wav")

var hob_happy = [preload("res://assets/sounds/hob_happy1.wav"), preload("res://assets/sounds/hob_happy2.wav"), preload("res://assets/sounds/hob_happy3.wav")]
var gob_happy = [preload("res://assets/sounds/gob_happy2.wav"), preload("res://assets/sounds/gob_happy3.wav")]

var gob_unhappy = [preload("res://assets/sounds/gob_unhappy1.wav"), preload("res://assets/sounds/gob_unhappy2.wav"), preload("res://assets/sounds/gob_unhappy3.wav")]
var hob_unhappy = [preload("res://assets/sounds/hob_unhappy1.wav"), preload("res://assets/sounds/hob_unhappy2.wav"), preload("res://assets/sounds/hob_unhappy3.wav")]

var coin_spawn = preload("res://assets/sounds/coin_spawn.wav")
var coin_collect = preload("res://assets/sounds/coin_collect.wav")

var active_qte: QTE
@export var time_since_coin: float = 0.0

var coin = preload("res://scenes/coin.tscn") 
var coin_instance

@export var coin_present = false


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
var battle_is_clash = false
	
func roll_finished(r: DiceRoller, roll:int):
	if r == dice1:
		$GoblinBar1.value += roll
		dice2.prefer_roll = roll
	else:
		$GoblinBar2.value += roll
		dice1.prefer_roll = roll
	if dice1.is_rolled && dice2.is_rolled:
		print("BOTH ROLL")
		dice1.is_rolled = false
		dice2.is_rolled = false
		dice1.prefer_roll = -1
		dice2.prefer_roll = -1
		timer.wait_time = 0.5
		timer.one_shot = true 
		timer.start()
		
		if dice1.last_roll == 6 && dice2.last_roll == 6:
			print("implement")
			dice1.event_counter = 0
			dice2.event_counter = 0
			roller = r
			$BattleText.text = "Clash Battle"
			battle_is_clash = true
			start_battle()
			return
		
		# if both are the same do qte
		if dice1.spr.frame == dice2.spr.frame && dice1.score > 0 && dice2.score > 0:
			timer.wait_time = 100
			timer.one_shot = true 
			timer.start()
			$BattleText.text = "Event Battle"
			qte_is_battle = false
			dice1.event_counter = 0
			dice2.event_counter = 0
			await get_tree().create_timer(0.5).timeout
			$AudioStreamPlayer2D.stream = qte_start
			$AudioStreamPlayer2D.play()
			await get_tree().create_timer(1.0).timeout
			start_qte(qte_scenes[randi() % len(qte_scenes)])
		if dice1.spr.frame == 5:
			roller = dice1
			roller.event_counter = 0
			$BattleText.text = "Battle"
			battle_is_clash = false
			start_battle()
		if dice2.spr.frame == 5:
			roller = dice2
			$BattleText.text = "Battle"
			battle_is_clash = false
			roller.event_counter = 0
			start_battle()
		
func start_battle():
#	prevent input
	timer.wait_time = 20
	timer.one_shot = true 
	timer.start()
	
	qte_is_battle = true
	await get_tree().create_timer(0.5).timeout
	$AudioStreamPlayer2D.stream = battle_start
	$AudioStreamPlayer2D.play()
	await get_tree().create_timer(1.0).timeout
	start_qte(preload("res://irl_qte.tscn"))

func start_qte(scene):
#	prevent input
	timer.wait_time = 2
	timer.one_shot = true 
	timer.start()
	
	
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
	print("dice %s won" % whoWon)
	if !qte_is_battle:
		$WinQTEText.visible = true
		if whoWon == dice1:
			$WinQTEText.text = "Goblin Victory"
		if whoWon == dice2:
			$WinQTEText.text = "Hobgoblin Victory"
	
	$WinQTEText.visible = false
	if qte_is_battle:
		if battle_is_clash:
			whoWon.score += 1
			if whoWon == dice1:
				splash_frame($Goblin, 3)
				$AudioStreamPlayer2D.stream = gob_happy.pick_random()
				$AudioStreamPlayer2D.play()
				splash_frame($Hobgoblin, 1)
				$AudioStreamPlayer2D.stream = hob_unhappy.pick_random()
				$AudioStreamPlayer2D.play()
			else:
				splash_frame($Goblin, 1)
				$AudioStreamPlayer2D.stream = gob_unhappy.pick_random()
				$AudioStreamPlayer2D.play()
				splash_frame($Hobgoblin, 3)
				$AudioStreamPlayer2D.stream = hob_happy.pick_random()
				$AudioStreamPlayer2D.play()
		else:
			if whoWon == roller:
				roller.score += 1
				if roller == dice1:
					splash_frame($Goblin, 3)
					$AudioStreamPlayer2D.stream = gob_happy.pick_random()
					$AudioStreamPlayer2D.play()
				else:
					splash_frame($Hobgoblin, 3)
					$AudioStreamPlayer2D.stream = hob_happy.pick_random()
					$AudioStreamPlayer2D.play()
			else:
				if roller == dice1:
					$AudioStreamPlayer2D.stream = gob_unhappy.pick_random()
					$AudioStreamPlayer2D.play()
				if roller == dice2:
					$AudioStreamPlayer2D.stream = hob_unhappy.pick_random()
					$AudioStreamPlayer2D.play()
	else:
		if whoWon == dice1:
			dice2.score -= 1
			dice1.score += 1
			splash_frame($Goblin, 3)
			splash_frame($Hobgoblin, 1)
			$AudioStreamPlayer2D.stream = gob_happy.pick_random()
			$AudioStreamPlayer2D.play()
		else:
			dice1.score -= 1
			dice2.score += 1
			splash_frame($Goblin, 1)
			splash_frame($Hobgoblin, 3)
			$AudioStreamPlayer2D.stream = hob_happy.pick_random()
			$AudioStreamPlayer2D.play()
			
	
	await get_tree().create_timer(2).timeout
	timer.stop()
	change_state(GameState.DICE)

func splash_frame(who: AnimatedSprite2D, frame: int):
	who.frame = frame
	await get_tree().create_timer(1.5).timeout
	who.frame = 0
func _ready() -> void:
	$GoblinBar1.value = 0
	$GoblinBar2.value = 0
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
		
func reset_coins(coin_ui: Node2D) -> void:
	for i in 4:
		coin_ui.get_node("c" + str(i + 1)).visible = false

func update_coins(coin_ui: Node2D, coin_count: int) -> void:
	reset_coins(coin_ui)
	
	for i in coin_count:
		coin_ui.get_node("c" + str(i + 1)).visible = true

func reset_bonus(bonus: Label) -> void:
	bonus.visible = false
	
func update_bonus(bonus: Label, bonus_amount: int) -> void:
	reset_bonus(bonus)
	
	if bonus_amount > 0:
		bonus.text = "+" + str(bonus_amount)
		bonus.visible = true

func _process(delta):
	if state == GameState.DICE:
		time_since_coin += delta
	
	if state == GameState.DICE && timer.is_stopped():
		if time_since_coin > 20 && coin_present == false:
			$AudioStreamPlayer2D.stream = coin_spawn
			$AudioStreamPlayer2D.play()
			coin_instance = coin.instantiate()
			add_child(coin_instance)
			coin_present = true
			time_since_coin = 0
		
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
			
		if coin_present:
			if Input.is_action_just_pressed("player1CollectCoin"):
				dice1.coins = min(4, dice1.coins + 1)
				coin_instance.queue_free()
				coin_present = false
				$AudioStreamPlayer2D.stream = coin_collect
				$AudioStreamPlayer2D.play()
				
			
			if Input.is_action_just_pressed("player2CollectCoin"):
				dice2.coins = min(4, dice2.coins + 1)
				coin_instance.queue_free()
				coin_present = false
				$AudioStreamPlayer2D.stream = coin_collect
				$AudioStreamPlayer2D.play()
		else:
			if Input.is_action_just_pressed("player1CollectCoin") && dice1.coins > 0:
				dice1.coins -= 1
				dice1.bonus += 1
				
			if Input.is_action_just_pressed("player2CollectCoin") && dice2.coins > 0:
				dice2.coins -= 1
				dice2.bonus += 1
				
		update_score(score1, dice1.score)
		update_score(score2, dice2.score)
		update_coins(coin1, dice1.coins)
		update_coins(coin2, dice2.coins)
		update_bonus(bonus1, dice1.bonus)
		update_bonus(bonus2, dice2.bonus)
		
	if state == GameState.WIN:
		win_vignette.visible = true
		win_text.text = winner + " wins!"
		win_text.visible = true
