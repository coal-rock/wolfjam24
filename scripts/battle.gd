extends Node2D
class_name Battle

@export var dice1: DiceRoller
@export var dice2: DiceRoller

@export var inputName1: String
@export var inputName2: String

@onready var vignete = $Vignete 

enum GameState { DICE, QTE, MENU }

@export var state = GameState.DICE

var qte_scene = preload("res://node_2d_qte.tscn")
var active_qte: QTE
func change_state(s: GameState):
	state = s
	if state == GameState.QTE:
		vignete.visible = true
	else:
		vignete.visible = false

func handle_roll(r: DiceRoller) -> void:
	r.update_die()
	
	if dice1.is_rolled && dice2.is_rolled:
		print("BOTH ROLL")
		dice1.is_rolled = false
		dice2.is_rolled = false
		
		# now if both have a roll, start the battle	
		if dice1.spr.frame == dice2.spr.frame:
			change_state(GameState.QTE)
			$BattleText.visible = true
			await get_tree().create_timer(2).timeout
			$BattleText.visible = false
			print("BOTH MATCH")
			active_qte = qte_scene.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
			active_qte.battle = self
			get_tree().get_root().add_child(active_qte)

	
	
# called by the qte script
func qte_finished():
	active_qte.queue_free()
	change_state(GameState.DICE)
	

func _on_ready() -> void:	
	handle_roll(dice1)
	handle_roll(dice2)

func _process(delta):
	if state == GameState.DICE:
		if Input.is_action_just_pressed(inputName1):
			handle_roll(dice1)
		if Input.is_action_just_pressed(inputName2):
			handle_roll(dice2)
