extends Control
enum {
	RAW,
	BBCODE,
	HTML
}
var terminal : String
var rawterm : String
var export_flag : int = RAW
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func alephone_to_bbcode(term : String) -> String:
	
	term = '[color=lime]' + term
	term = term.replace("$C0", '[/color][color=lime]')
	term = term.replace("$C1", '[/color][color=white]')
	term = term.replace("$C2", '[/color][color=red]')
	term = term.replace("$C3", '[/color][color=green]')
	term = term.replace("$C4", '[/color][color=aqua]')
	term = term.replace("$C5", '[/color][color=yellow]')
	term = term.replace("$C6", '[/color][color=maroon]')
	term = term.replace("$C7", '[/color][color=blue]')
	term = term.replace("$I", "[i]") # Replaces italics
	term = term.replace("$i", "[/i]") 
	term = term.replace("$B", "[b]") # Replaces bold
	term = term.replace("$b", "[/b]")
	term = term.replace("$U", "[u]") # Replaces underlined
	term = term.replace("$u", "[/u]")
	print(term.count("[b]"))
	print(term.count("[/b]"))
	term = term.replace("[/b][/color]", "[/color][/b]")
	term = fix_bolds(term)
	term = term + "[/color]"
	terminal = term
	return term
#0 	Light Green 	Color0
#1 	White 	Color1
#2 	Red 	Color2
#3 	Dark Green 	Color3
#4 	Light Blue 	Color4
#5 	Yellow 	Color5
#6 	Dark Red 	Color6
#7 	Dark Blue 	Color7
#8 	No color 	Color8
#9 	No color 	Color9
func fix_bolds(term : String):
	var colors = ["lime", "white", "red", "green", "aqua", "yellow",
		"maroon", "blue"]
	var labels = ["[b]","[u]","[i]"]
#	var Exp : RegEx = RegEx.new()
#	Exp.compile("\\[\\/color\\]\\[color\\=([a-z]*)\\]\\[b\\]")
#	var result : RegExMatch = Exp.search(term)
	for color in colors:
		for label in labels:
			term = term.replace("[/color][color="+color+"]"+label, "[/color]"+label+"[color="+color+"]")
	for color in colors:
		for label in labels:
			term = term.replace(label+"[/color][color="+color+"]", "[/color]"+label+"[color="+color+"]")
	return term
	

func _on_Open_pressed():
	$HBoxContainer/GridContainer/Open/FileDialog.popup()
	



func _on_FileDialog_file_selected(path):
	var current : File = File.new()
	var text : String
	current.open(path, File.READ)
	text = current.get_as_text()
	$VBoxContainer/HBoxContainer/SplitContainer/Editor/Inline.text = text
	update_terms()

func _on_Button_pressed():
	$HBoxContainer/SplitContainer/Editor/Inline.text = terminal


func _on_Update_pressed():
	update_terms()

func update_terms():
	rawterm = $VBoxContainer/HBoxContainer/SplitContainer/Editor/Inline.text
	$VBoxContainer/HBoxContainer/SplitContainer/Previewer.split_terminals(alephone_to_bbcode(rawterm))


func _on_Toolbar_file_option_selected(id : int):
	if id == 0:
		$VBoxContainer/PanelContainer/OpenDialog.popup_centered()
	else:
		if id == 1:
			export_flag = RAW
		elif id == 2: 
			export_flag = BBCODE
		$VBoxContainer/PanelContainer/SaveDialog.popup_centered()
	

func _on_SaveDialog_file_selected(path):
	var file :File = File.new()
	file.open(path, File.WRITE)
	file.seek_end()
	if export_flag == RAW:
		file.store_line(rawterm)
	elif export_flag == BBCODE:
		file.store_line(terminal)
	file.close()


