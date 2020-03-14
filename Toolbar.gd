extends HBoxContainer

signal file_option_selected(id)
signal about_option_selected(id)
onready var file_menu : Popup = $File.get_popup()
onready var about_menu : Popup = $About.get_popup()
func _ready():
	file_menu.connect("id_pressed", self, "_on_File_item_selected")
	about_menu.connect("id_pressed", self, "_on_About_item_selected")
func _on_File_item_selected(id : int):
	emit_signal("file_option_selected", id)

func _on_About_item_selected(id : int):
	emit_signal("about_option_selected", id)
