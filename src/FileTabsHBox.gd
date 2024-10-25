extends HBoxContainer

signal file_tab_pressed(index)
onready var file_tab = preload("res://src/FileTab.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func load_file_tabs(titles):
	for index in range(titles.size()):
		var title = titles[index]
		add_tab(title, index)
		
func add_tab(title, index):
	var new_file_tab = file_tab.instance()
	new_file_tab.connect("TabButtonPressed", self, "on_file_tab_button_pressed", [index])
	add_child(new_file_tab)
	new_file_tab.title = title
	
func set_tab_title(title, index):
	self.get_child(index).title = title
		
func on_file_tab_button_pressed(index):
	emit_signal("file_tab_pressed", index)
