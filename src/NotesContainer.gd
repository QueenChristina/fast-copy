extends ScrollContainer

var DEFAULT_FONT_COLOR = Color(1, 1, 1)
var data_notes = [
	{
		"type": "CopyNote",
		"text" : "Default copy this text.",
		"font_color" : DEFAULT_FONT_COLOR
	}, 
	{
		"type": "MultiNote",
		"text" : "Multiline text.",
		"font_color" : DEFAULT_FONT_COLOR
	},
	{
		"type": "Note",
		"text" : "Single line text.",
		"font_color" : DEFAULT_FONT_COLOR
	},
]

onready var notes_vbox = $"Notes"
onready var multinote = preload("res://src/MultiNote.tscn")
onready var copytext = preload("res://src/CopyText.tscn")
onready var linenote = preload("res://src/Note.tscn")
onready var title_line = $"Notes/Title/LineEdit"
var curr_selected_note

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func clear_notes():
	data_notes = []
	var num_notes = notes_vbox.get_child_count() - 2
	if num_notes > 0:
		for child_index in range(notes_vbox.get_child_count() - 2, 0, -1):
			# Excluding Add Hbox and Title
			var note_child = notes_vbox.get_children()[child_index]
			notes_vbox.remove_child(note_child)
			note_child.queue_free()
			curr_selected_note = null

# Notes given as dictionary
func load_data(notes, title = ""):
	for note in notes:
		if note.type == "CopyNote":
			add_note_child(copytext, false, note.text, note.font_color)
		if note.type == "MultiNote":
			add_note_child(multinote, false, note.text, note.font_color)
		if note.type == "Note":
			add_note_child(linenote, false, note.text, note.font_color)
			
func add_note_child(scene, add_to_data = false, txt = "", font_color = DEFAULT_FONT_COLOR):
	var new_child = scene.instance()
	notes_vbox.add_child(new_child)
	notes_vbox.move_child(new_child, notes_vbox.get_child_count() - 2)
	new_child.connect("pressed", self, "on_note_selected", [new_child])
	
	new_child.content_text = txt
	new_child.font_color = font_color
	
	if add_to_data:
		var type = "CopyNote"
		if scene == multinote:
			type = "MultiNote"
		elif scene == linenote:
			type = "Note"
		add_data_note(type, txt, font_color)

func on_note_selected(node):
	curr_selected_note = node
	print(node)
	
func add_data_note(type, text, font_color = DEFAULT_FONT_COLOR):
	data_notes.append({
		"type": type,
		"text": text, 
		"font_color" : font_color
		})
	
# Syncs data_notes to current child structure
func update_data_notes():
	data_notes = []
	# Exclude title and settings
	for i in range(1, notes_vbox.get_child_count() - 1):
		var note = notes_vbox.get_child(i)
		add_data_note(note.type, note.content_text, note.font_color)
	
func _on_AddCopyText_pressed():
	add_note_child(copytext, true)
	
func _on_AddMultiNote_pressed():
	add_note_child(multinote, true)

func _on_AddNote_pressed():
	add_note_child(linenote, true)


func _on_DeleteNote_pressed():
	if curr_selected_note:
		# Subtract 1 to account for title
		data_notes.remove(curr_selected_note.get_index() - 1)
		notes_vbox.remove_child(curr_selected_note)
		curr_selected_note.queue_free()
		curr_selected_note = null

func _on_ShiftDown_pressed():
	if curr_selected_note:
		var old_data_ind = curr_selected_note.get_index() - 1 # account for Title, index in data
		var new_ind = clamp_valid_notes_index(curr_selected_note.get_index() + 1)
		notes_vbox.move_child(curr_selected_note, new_ind)
		if old_data_ind < notes_vbox.get_child_count() - 3:
			var old_data = data_notes.pop_at(old_data_ind)
			data_notes.insert(old_data_ind + 1, old_data)

func _on_ShiftUp_pressed():
	if curr_selected_note:
		var old_data_ind = curr_selected_note.get_index() - 1 # account for Title, index in data
		var new_ind = clamp_valid_notes_index(curr_selected_note.get_index() - 1)
		notes_vbox.move_child(curr_selected_note, new_ind)
		if old_data_ind > 0:
			var old_data = data_notes.pop_at(old_data_ind)
			data_notes.insert(old_data_ind - 1, old_data)

func clamp_valid_notes_index(index):
	return clamp(index, 1, notes_vbox.get_child_count() - 2)
