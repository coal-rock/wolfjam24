extends Label


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var opening_text = "The Goblin and the Hobgoblin tribes have fought bloody wars for hundreds of generations.
\nHowever, recently, instead of gruesome and taxing battles, the two groups have decided to settle disagreements not with warfare, but with dice.
\nGoblin Dice has been in practice for thousands of…minutes now and tensions have stayed cool.
\nWill this non-aggression pact stand tall?"
func _ready() -> void:
	scroll_text(opening_text)
	
func scroll_text(input_text:String) -> void:
	visible_characters = 0
	text = input_text
	
	for i in text.length():
		visible_characters += 1
		await get_tree().create_timer(0.1).timeout
