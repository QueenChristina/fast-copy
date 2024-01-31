extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var original_str = OS.get_clipboard()
	var display_str = original_str.substr(0, 100)
	if len(original_str) > 100:
		display_str += "..."
	display_str = display_str.replace("\n", " ... ")
	self.text = "Copied \"" + display_str + "\""
