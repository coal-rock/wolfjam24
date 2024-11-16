extends RichTextLabel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var opening_text = "This is some example text.\nThis is a newline."

func _ready() -> void:
	scroll_text(opening_text)
	
func scroll_text(input_text:String) -> void:
	visible_characters = 0
	text = input_text
	
	for i in get_parsed_text():
		visible_characters += 1
		await get_tree().create_timer(0.1).timeout
