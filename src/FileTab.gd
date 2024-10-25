extends PanelContainer

signal TabButtonPressed
signal CloseTabButtonPressed
var title = "Untitled File" setget set_title
onready var tab_button = $"HBox/TabButton"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_CloseButton_pressed():
	emit_signal("CloseTabButtonPressed")

func _on_TabButton_pressed():
	emit_signal("TabButtonPressed")

func set_title(title):
	tab_button.text = title
