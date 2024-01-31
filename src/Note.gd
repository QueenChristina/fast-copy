extends Button

var type = "Note"
export(String) var content_text = "" setget set_text
export(Color) var font_color setget set_font_color
onready var line_edit = $MarginContainer/LineEdit
onready var font_color_picker = $"MarginContainer/LineEdit/ColorPickerButton"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# For some reason, if you click on lineEdit the mouse filter pass doesn't work -_-
# so manually emit this signal
func _on_LineEdit_focus_entered():
	emit_signal("pressed")

func set_text(txt):
	content_text = txt
	line_edit.text = txt

func set_font_color(color):
	font_color = color
	line_edit.set("custom_colors/font_color", color)
	if font_color_picker.color != color:
		font_color_picker.color = color

func _on_LineEdit_text_changed(new_text):
	content_text = line_edit.text
