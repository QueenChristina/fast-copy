extends ColorPickerButton

export(NodePath) var text_edit_path

# Called when the node enters the scene tree for the first time.
func _ready():
	self.color = get_node(text_edit_path).get("custom_colors/font_color")

func _on_ColorPickerButton_color_changed(color):
	get_node(text_edit_path).set("custom_colors/font_color", color)
