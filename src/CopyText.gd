extends Button

var type = "CopyNote"
export(String) var content_text = "" setget set_text
export(Color) var font_color setget set_font_color
onready var text_edit = $HBox/TextEdit
onready var font_color_picker = $"HBox/TextEdit/ColorPickerButton"

onready var copyButton = $"HBox/CopyButton"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_CopyButton_pressed():
	OS.set_clipboard(text_edit.text)
	print("Copied \"" + text_edit.text.substr(0, 20) + "\"")

func set_text(txt):
	content_text = txt
	text_edit.text = txt

func set_font_color(color):
	font_color = color
	text_edit.set("custom_colors/font_color", color)
	if font_color_picker.color != color:
		font_color_picker.color = color
		
func _on_TextEdit_text_changed():
	content_text = text_edit.text
