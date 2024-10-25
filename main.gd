extends Control

const FILE_NAME = "user://fast-copy-data.json"
onready var notes_container = $VBoxContainer/NotesContainer
onready var file_tabs_container = $"VBoxContainer/Menu/Tabs/ScrollContainer/HBoxContainer/FileTabsHBox"

var files_data = []
# The current selected file to display.
var selected_file_index = 0
var default_file_data = {
	"notes": [{
		"type": "CopyNote",
		"text" : "Default copy this text.",
		"font_color" : Color(1, 1, 1),
	}],
	"title" : "Untitled File"
}

func _ready():
	load_data()

# data in json format
func save():
	var serialized_notes = []
	notes_container.update_data_notes()
	for note in notes_container.data_notes:
		note.font_color = note.font_color.to_html()
		serialized_notes.append(note)
		
	var file_data = {
		"title" : notes_container.title_line.text,
		"notes": serialized_notes
	}
	
	files_data[selected_file_index] = file_data
	
	var file = File.new()
	file.open(FILE_NAME, File.WRITE)
	file.store_string(to_json(files_data))
	file.close()
	
	file_tabs_container.set_tab_title(files_data[selected_file_index].title, selected_file_index)

func load_data():
	var file = File.new()
	if file.file_exists(FILE_NAME):
		file.open(FILE_NAME, File.READ)
		files_data = parse_json(file.get_as_text())
#		print(OS.get_data_dir())
		file.close()
		if typeof(files_data) == TYPE_DICTIONARY:
			# Only one file (old format). Convert to new format
			files_data = [files_data]
		if typeof(files_data) == TYPE_ARRAY:
			# Multiple files.
			for file_index in range(files_data.size()):
				file_tabs_container.add_tab(files_data[file_index].title, file_index)
			load_file(files_data[selected_file_index])
		else:
			printerr("Corrupted data!")
			notes_container.load_data(notes_container.data_notes)
	else:
		printerr("No saved data!")
		notes_container.load_data(notes_container.data_notes)

func load_file(file_data):
	notes_container.title_line.text = file_data.title
	# clear old notes
	notes_container.clear_notes()
	# load notes
	var unserialized_notes = []
	for note in file_data.notes:
		note.font_color = Color(note.font_color)
		unserialized_notes.append(note)
	notes_container.data_notes = unserialized_notes
	notes_container.load_data(unserialized_notes)

func _on_Save_pressed():
	save()

func _on_AddFileTab_pressed():
	files_data.append(default_file_data)
	var index = file_tabs_container.get_child_count()
	file_tabs_container.add_tab(default_file_data.title, index)
	
	selected_file_index = index
	load_file(files_data[selected_file_index])

# Switch to new tab's file
func _on_FileTabsHBox_file_tab_pressed(index):
	# Save old file settings.
	save()
	# Switch to new file.
	selected_file_index = index
	load_file(files_data[selected_file_index])
