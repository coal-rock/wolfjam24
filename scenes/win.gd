extends Node2D

var coin = preload("res://scenes/coin.tscn")
var elapsed_time = 0
#hack

@export var coin_present = false 

@onready var hobgoblin_win: Sprite2D = $hobgoblin_win
@onready var goblin_win: Sprite2D = $goblin_win
@onready var text: Label = $Label

@onready var gob_win = [preload("res://assets/sounds/Gob Victory 1.wav"), preload("res://assets/sounds/Gob Victory 2.wav"), preload("res://assets/sounds/Gob Victory 3.wav"), preload("res://assets/sounds/Gob Victory 4.wav")]
@onready var hob_win = [preload("res://assets/sounds/Hobgoblin Victory 1.wav"), preload("res://assets/sounds/Hobgoblin Victory 2.wav"), preload("res://assets/sounds/Hobgoblin Victory 3.wav"), preload("res://assets/sounds/Hobgoblin Victory 4.wav")]

@export var winner: String
@export var text_var: String
@export var hog_visible: bool
@export var gob_visible: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text_var = Globals.winner + " Wins"
	print(Globals.winner)
	if Globals.winner == "Hobgoblin":
		hog_visible = true
	elif Globals.winner == "Goblin":
		gob_visible = true
		
	if Globals.winner == "Goblin":
		$AudioStreamPlayer2D.stream = gob_win.pick_random()
		$AudioStreamPlayer2D.play()
	else:
		$AudioStreamPlayer2D.stream = hob_win.pick_random()
		$AudioStreamPlayer2D.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	elapsed_time += delta
	
	if elapsed_time > 0.5:
		add_child(coin.instantiate())
		
	text.text = text_var
	hobgoblin_win.visible = hog_visible
	goblin_win.visible = gob_visible
		
