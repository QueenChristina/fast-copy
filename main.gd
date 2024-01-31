extends Control

const FILE_NAME = "user://fast-copy-data.json"
onready var notes_container = $VBoxContainer/NotesContainer
onready var title_line = $"VBoxContainer/NotesContainer/Notes/Title/LineEdit"

func _ready():
	load_data()

# data in json format
func save():
	var serialized_notes = []
	notes_container.update_data_notes()
	for note in notes_container.data_notes:
		note.font_color = note.font_color.to_html()
		serialized_notes.append(note)
		
	var data = {
		"title" : title_line.text,
		"notes": serialized_notes
	}
	
	var file = File.new()
	file.open(FILE_NAME, File.WRITE)
	file.store_string(to_json(data))
	file.close()

func load_data():
	var file = File.new()
	if file.file_exists(FILE_NAME):
		file.open(FILE_NAME, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			# Load into reality
			title_line.text = data.title
			var unserialized_notes = []
			for note in data.notes:
				note.font_color = Color(note.font_color)
				unserialized_notes.append(note)
			notes_container.data_notes = unserialized_notes
			notes_container.load_data(unserialized_notes)
		else:
			printerr("Corrupted data!")
			notes_container.load_data(notes_container.data_notes)
	else:
		printerr("No saved data!")
		notes_container.load_data(notes_container.data_notes)


func _on_Save_pressed():
	save()
